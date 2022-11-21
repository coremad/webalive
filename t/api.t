#!/usr/bin/perl
use strict;
use warnings;
use Mojo::Base;
use Test::More;
use Test::Mojo;

use v5.20;

my $t = Test::Mojo->new('WebAlive');

$t->get_ok('/api/new_urls_count')->status_is(200)->content_like(qr/^\d+$/);
$t->get_ok('/api/url_count')->status_is(200)->content_like(qr/^\d+$/);

done_testing();

