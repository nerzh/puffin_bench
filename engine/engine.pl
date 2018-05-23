#!/usr/bin/perl

use Time::HiRes qw(gettimeofday tv_interval);

my $start;
my $end;
my $name;

$start = [gettimeofday];

$name = `$ARGV[0]`;

$end = tv_interval($start);

print "$name - $end sec.\n";

1;
