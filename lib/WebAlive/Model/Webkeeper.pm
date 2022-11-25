package WebAlive::Model::Webkeeper;
use strict;
use warnings FATAL => 'all';
use Mojo::Base 'Mojolicious', -signatures;
use Mojo::Log;
use YAML qw(LoadFile);
use DBI;
use IO::Select;

my $config;
my $log;

sub new($class) {
    my $self = bless {}, $class;
    $log = Mojo::Log->new;
    use Mojo::File qw(curfile);
    $config = LoadFile(curfile->dirname->sibling('../../web_alive.yml')->to_string)
        or die("config web_alive.yml not found");
    my $dbconn = $config->{dbconn};
    do {
        eval {
            $self->{dbh} = DBI->connect("dbi:Pg:dbname=$dbconn->{dbname};host=$dbconn->{host};port=$dbconn->{port}",
                $dbconn->{username},
                $dbconn->{password},
                { AutoCommit => 1, RaiseError => 0 }) or $log->error(DBI::err);
            };
        sleep(5) unless $self->{dbh};
    } until ($self->{dbh});
    return($self);
}

sub start_listen {
    my ($self, $func) = @_;
    my $term = 0;
    $SIG{$_}  = sub { $term = 1; $log->info("Listener Exiting..."); } for('INT', 'TERM', 'QUIT');
    $self->{dbh}->do("LISTEN urls_inserts");
    my $fd = $self->{dbh}->func("getfd");
    my $sel = IO::Select->new($fd);
    $log->info('Listener started...');
    do {
        $sel->can_read;
        while(my $notify = $self->{dbh}->pg_notifies) {
            my($topic, $pid, $msg) = @$notify;
            $log->info("Got message from $pid: $topic => $msg");
            $func->($msg);
        }
    } until ($term);

    $log->info('Listener terminated');
}

sub list ($self) {
    my $sth = $self->{dbh}->prepare('SELECT * FROM "logs_list"');
    $sth -> execute();
    my $rows = $sth->fetchall_hashref('url_id');
    foreach my $k (keys %{$rows}) {
        $sth = $self->{dbh}->prepare('SELECT * FROM "headers_list" WHERE log_id = ? LIMIT ?');
        $sth -> execute($rows->{$k}->{id}, $config->{max_headers});
        $rows->{$k}->{headers} = $sth->fetchall_arrayref();
    }
    return($rows);
}

sub add_url {
    my ($self, $url) =  @_;
    my $sql = 'INSERT INTO urls (url) VALUES ( ? ) ON CONFLICT DO NOTHING RETURNING id';
    my $sth = $self->{dbh}->prepare($sql);
    my $res = $sth -> execute($url) or return(0);
    return(-1) if $res eq "0E0";
    return($sth->fetchrow_hashref()->{id});
}

sub get_new_urls($self) {
    my $sth = $self->{dbh}->prepare('SELECT * FROM new_urls');
    $sth -> execute();
    my $url_hash = $sth -> fetchall_hashref('id');
    return [map { $url_hash->{$_} } keys %$url_hash];
}

sub new_urls_count($self) {
    my $sth = $self->{dbh}->prepare('SELECT COUNT(*) FROM new_urls');
    $sth -> execute();
    return $sth -> fetchrow_hashref()->{count};
}

sub del_url {
    my ($self, $id) =  @_;
    my $sth = $self->{dbh}->prepare('DELETE FROM urls WHERE id = ?');
    return $sth -> execute($id);
}

sub ins_val {
    my ($self, $table, $col, $str) = @_;
    my $sql = 'INSERT INTO '.$table . ' (' . $col . ') VALUES( ? ) ON CONFLICT DO NOTHING returning id';
    my $sth = $self->{dbh}->prepare($sql);
    if ($sth->execute("$str") and my $tmp = $sth->fetchrow_hashref() ) {
        return($tmp->{id});
    }
    $sth = $self->{dbh}->prepare("SELECT id FROM $table WHERE $col = ?");
    $sth -> execute("$str") and return $sth->fetchrow_hashref()->{id};

    return(0);
}

sub ins_log {
    my ($self, $url_id, $status) = @_;
    my $sql = "INSERT INTO logs(url_id, status) VALUES( ?, ? ) returning id";
    my $sth = $self->{dbh}->prepare($sql);
    $sth -> execute($url_id, $status) or return(0);
    return $sth->fetchrow_hashref()->{id}
}

sub ins_header {
    my ($self, $log_id, $header_name, $header) = @_;
    my $name_id = $self->ins_val('header_names', 'name', $header_name);
    my $val_id = $self->ins_val('header_values', 'val', $header);
    my $sth = $self->{dbh}->prepare("INSERT INTO headers(log_id, hn_id, hv_id) VALUES( ?, ?, ? )");
    $sth->execute($log_id, $name_id, $val_id);
}

sub url_list($self) {
    my $sth = $self->{dbh}->prepare('SELECT id, url FROM "urls" WHERE enabled = true');
    $sth -> execute();
    my $url_hash = $sth -> fetchall_hashref('id');
    return [map { $url_hash->{$_} } sort  {$a < $b} keys %$url_hash];
}

sub DESTROY($self) {
    $self->{dbh}->disconnect if $self->{dbh};
}

sub config{
    $config;
}

1;

=pod

BEGIN
    PERFORM (
        WITH url_row("id", "url") AS (
            SELECT NEW.id, NEW.url
        )
        SELECT pg_notify('urls_inserts', row_to_json(url_row) :: TEXT)
        FROM url_row
    );
    RETURN NULL;
END

CREATE TRIGGER urls_trigger
    AFTER INSERT ON urls
        FOR EACH ROW EXECUTE PROCEDURE urls_on_insert();
