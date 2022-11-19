package WebAlive::Model::Webkeeper;
use strict;
use warnings FATAL => 'all';
use Mojo::Base 'Mojolicious', -signatures;
use WebAlive;
use JSON;
use DBI;

use Data::Dumper;

my $dbh;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    my $dbconn;
    $dbconn = shift or $dbconn = WebAlive::myconfig->{dbconn};
    $dbh = DBI -> connect("dbi:Pg:dbname=$dbconn->{dbname};host=$dbconn->{host};port=$dbconn->{port}",
        $dbconn->{username},
        $dbconn->{password},
        { AutoCommit => 1, RaiseError => 0 }
    ) or die $DBI::errstr;
    return($self);
}

sub list ($self) {
    my $sql = 'SELECT * FROM "logs_list"';
    my $sth = $dbh->prepare($sql);
    $sth -> execute();
    my $rows = $sth->fetchall_hashref('id');
    foreach my $k (keys %{$rows}) {
        my $sql = 'SELECT * FROM "headers_list" WHERE log_id = ?';
        my $sth = $dbh->prepare($sql);
        $sth -> execute($k);
        $rows->{$k}->{headers} = $sth->fetchall_arrayref();
    }
    return($rows);
}

sub add_url {
    my ($self, $url) =  @_;
    my $sql = 'INSERT INTO observables (url) VALUES ( ? )  ON CONFLICT DO NOTHING returning id';
    my $sth = $dbh->prepare($sql);
    eval {say STDERR Dumper($sth -> execute($url));};
    # say STDERR $sth->fetchrow_hashref()->{id};
    return($sth->fetchrow_hashref()->{id});
}

sub del_url {
    my ($self, $id) =  @_;
    my $sql = 'DELETE FROM observables WHERE id = ?';
    my $sth = $dbh->prepare($sql);
    eval {say STDERR Dumper($sth -> execute($id));};
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
    my ($url_id, $status) = @_;
    my $sql = "INSERT INTO logs(url_id, status) VALUES( ?, ? ) returning id";
    my $sth = $dbh->prepare($sql);
    $sth -> execute($url_id, $status);
    return $sth->fetchrow_hashref()->{id}
}

sub ins_header {
    my ($log_id, $header_name, $header) = @_;
    my $name_id = ins_val('header_names', 'name', $header_name);
    my $val_id = ins_val('header_values', 'val', encode_json($header));
    my $sql = "INSERT INTO headers(log_id, hn_id, hv_id) VALUES( ?, ?, ? )";
    my $sth = $dbh->prepare($sql);
    $sth->execute($log_id, $name_id, $val_id);
}

sub get_url_by_id($id) {
    my $sql = 'SELECT * FROM "observables" WHERE id = ?';
    my $sth = $dbh->prepare($sql);
    $sth -> execute($id);
    return $sth->fetchrow_hashref();
}

sub check_url {
    my ($self, $row) = @_;
    my $ua  = Mojo::UserAgent->new;
    my $res;
    $row = get_url_by_id($row) unless (ref($row) eq 'HASH');
    eval {$res = $ua->get($row->{url})->result;};
    my $log_id = ins_log($row->{id}, $res->{code});
    return (0) unless exists $res->{code} and exists $res->headers->{headers};
    my $headers = $res->headers->{headers};
    my $header_count = 3;
    foreach my $header_name (keys %{$headers}) {
        ins_header($log_id, $header_name, $headers->{$header_name});
        --$header_count or last();
    }
}

sub url_list {
    my $self = shift;
    my $sql = 'SELECT * FROM "observables" WHERE enabled = true';
    my $sth = $dbh->prepare($sql);
    $sth -> execute();
    my $url_hash = $sth -> fetchall_hashref('id');
    return map { $url_hash->{$_} } keys %$url_hash;
}

sub check_all {
    my $self = shift;
    my $sql = 'SELECT * FROM "observables" WHERE enabled = true';
    my $sth = $dbh->prepare($sql);
    $sth -> execute();
    while (my $row = $sth->fetchrow_hashref()) {
        $self->check_url($row);
    }
}
sub DESTROY($self) {
    $dbh->disconnect;
}

1;
