use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  VERSION   => '0.01',
  PREREQ_PM => {
    'Mojolicious' => '9.22',
    'YAML',
    'DBI',
    'DBD::Pg',
  },
  test => {TESTS => 't/*.t'}
);
