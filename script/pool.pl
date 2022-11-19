#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::UserAgent;
use Mojo::File qw(curfile);
use lib curfile->dirname->sibling('lib')->to_string;
use WebAlive::Model::Webkeeper;

use Data::Dumper;

my $dbconn = {
    dbname => 'test',
    host => 'localhost',
    port => 5432,
    username => 'admin',
    password => 'admin',
};

my $keeper = WebAlive::Model::Webkeeper->new($dbconn);
my @url_list = $keeper->url_list;
$keeper = undef;

use POSIX ":sys_wait_h";

my $max_workers = 5;

my %kids;

$SIG{CHLD} = \&REAPER;
sub REAPER {
    my $kid;
    delete($kids{$kid}) while (($kid = waitpid(-1, &WNOHANG)) > 0);
    $SIG{CHLD} = \&REAPER;
}

foreach my $row(@url_list) {
    if (my $pid = fork()) {
        $kids{$pid} = $pid;
    } else {
        say ($row->{url});
        my $keeper = WebAlive::Model::Webkeeper->new($dbconn);
        $keeper->check_url($row);
        $keeper = undef;
        exit;
    }
    delete($kids{waitpid(-1, 0)}) while ($max_workers <= scalar keys %kids);
}

my $kid;
do {
    $kid = waitpid(-1, 0);
} while ($kid > 0 and delete($kids{$kid}));


# $keeper->check_all;
