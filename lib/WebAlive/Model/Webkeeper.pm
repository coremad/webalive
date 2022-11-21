package WebAlive::Model::Webkeeper;
use strict;
use warnings FATAL => 'all';
use Mojo::Base 'Mojolicious', -signatures;
use Mojo::Log;
use WebAlive;
use DBI;

my $dbh;
my $config;
my $log;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $log = Mojo::Log->new;
    $config = shift or $config = WebAlive::myconfig;
    my $dbconn = $config->{dbconn};
    do {
        eval {
            $dbh = DBI->connect("dbi:Pg:dbname=$dbconn->{dbname};host=$dbconn->{host};port=$dbconn->{port}",
                $dbconn->{username},
                $dbconn->{password},
                { AutoCommit => 1, RaiseError => 0 }) or $log->error(DBI::err);
            };
        sleep(5) unless $dbh;
    } until ($dbh);
    return($self);
}

sub list ($self) {
    my $sql = 'SELECT * FROM "logs_list"';
    my $sth = $dbh->prepare($sql);
    $sth -> execute();
    my $rows = $sth->fetchall_hashref('url_id');
    foreach my $k (keys %{$rows}) {
        my $sql = 'SELECT * FROM "headers_list" WHERE log_id = ?';
        my $sth = $dbh->prepare($sql);
        $sth -> execute($rows->{$k}->{id});
        $rows->{$k}->{headers} = $sth->fetchall_arrayref();
    }
    return($rows);
}

sub add_url {
    my ($self, $url) =  @_;
    my $sql = 'INSERT INTO urls (url) VALUES ( ? )  ON CONFLICT DO NOTHING returning id';
    my $sth = $dbh->prepare($sql);
    my $res = $sth -> execute($url) or return(0);
    return(-1) if $res == "0E0";
    return($sth->fetchrow_hashref()->{id});
}

sub get_new_urls($self) {
    my $sql = 'SELECT u.id, u.url  FROM urls as u LEFT JOIN logs as l ON l.url_id = u.id where l.url_id IS NULL ORDER BY u.id DESC';
    my $sth = $dbh->prepare($sql);
    $sth -> execute();
    my $url_hash = $sth -> fetchall_hashref('id');
    return map { $url_hash->{$_} } keys %$url_hash;
}

sub del_url {
    my ($self, $id) =  @_;
    my $sql = 'DELETE FROM urls WHERE id = ?';
    my $sth = $dbh->prepare($sql);
    $sth -> execute($id);
}

sub ins_val {
    my ($table, $col, $str) = @_;
    my $sql = 'INSERT INTO '.$table . ' (' . $col . ') VALUES( ? ) ON CONFLICT DO NOTHING returning id';
    my $sth = $dbh->prepare($sql);
    if ($sth->execute("$str") and my $tmp = $sth->fetchrow_hashref() ) {
        return($tmp->{id});
    }
    $sql = "SELECT id FROM $table WHERE $col = ?";
    $sth = $dbh->prepare($sql);
    $sth -> execute("$str") and return $sth->fetchrow_hashref()->{id};

    return(0);
}

sub ins_log {
    my ($self, $url_id, $status) = @_;
    my $sql = "INSERT INTO logs(url_id, status) VALUES( ?, ? ) returning id";
    my $sth = $dbh->prepare($sql);
    $sth -> execute($url_id, $status) or return(0);
    return $sth->fetchrow_hashref()->{id}
}

sub ins_header {
    my ($self, $log_id, $header_name, $header) = @_;
    my $name_id = ins_val('header_names', 'name', $header_name);
    my $val_id = ins_val('header_values', 'val', $header);
    my $sql = "INSERT INTO headers(log_id, hn_id, hv_id) VALUES( ?, ?, ? )";
    my $sth = $dbh->prepare($sql);
    $sth->execute($log_id, $name_id, $val_id);
}

sub get_url_by_id($id) {
    my $sql = 'SELECT * FROM "urls" WHERE id = ?';
    my $sth = $dbh->prepare($sql);
    $sth -> execute($id);
    return $sth->fetchrow_hashref();
}

sub url_list {
    my $self = shift;
    my $sql = 'SELECT id, url FROM "urls" WHERE enabled = true';
    my $sth = $dbh->prepare($sql);
    $sth -> execute();
    my $url_hash = $sth -> fetchall_hashref('id');
    return map { $url_hash->{$_} } sort  {$a < $b} keys %$url_hash;
}

sub url_count {
    my $self = shift;
    my $sql = 'select count(*) from logs_list';
    my $sth = $dbh->prepare($sql);
    $sth -> execute();
    my $res = $sth -> fetchrow_arrayref();
    return $res->[0];
}


sub DESTROY($self) {
    $dbh->disconnect if $dbh;
}

1;
