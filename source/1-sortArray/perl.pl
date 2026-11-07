#!/usr/bin/env perl
use strict;
use warnings;
use Time::HiRes qw(clock_gettime CLOCK_MONOTONIC);
sub shells_sort {
    my ($arr) = @_;
    my $gap = int(scalar(@{$arr}) / 2);
    while ($gap > 0) {
        my $i = $gap;
        while ($i < scalar(@{$arr})) {
            my $temp = $arr->[$i];
            my $j = $i;
            while ($j >= $gap && $arr->[$j - $gap] > $temp) {
                $arr->[$j] = $arr->[$j - $gap];
                $j = $j - $gap;
            }
            $arr->[$j] = $temp;
            $i = $i + 1;
        }
        $gap = int($gap / 2);
    }
}
sub run {
    my ($arr, $iterations, $seed) = @_;
    my $state = $seed;
    my $checksum = 0;
    my $c = 0;
    while ($c < $iterations) {
        my $k = 0;
        while ($k < scalar(@{$arr})) {
            $state = ($state * 1664525 + 1013904223) & 2147483647;
            $arr->[$k] = ($state >> 8) & 65535;
            $k = $k + 1;
        }
        shells_sort($arr);
        $k = 0;
        while ($k < scalar(@{$arr})) {
            $checksum = ($checksum * 31 + $arr->[$k]) & 2147483647;
            $k = $k + 1;
        }
        $c = $c + 1;
    }
    return $checksum;
}
sub argument {
    my ($index, $fallback) = @_;
    return $fallback unless defined $ARGV[$index];
    die "Invalid argument" unless $ARGV[$index] =~ /^\d+$/ && $ARGV[$index] <= 2147483647;
    return 0 + $ARGV[$index];
}
die "iterations [seed [warmup]]" unless @ARGV >= 1 && @ARGV <= 3;
my $iterations = argument(0, 0);
my $seed = argument(1, 12345);
my $warmup = argument(2, 10000);
my $arr = [(0) x 100];
my $warmup_checksum = run($arr, $warmup, $seed);
my $start = clock_gettime(CLOCK_MONOTONIC);
my $checksum = run($arr, $iterations, $seed);
my $elapsed = int((clock_gettime(CLOCK_MONOTONIC) - $start) * 1000000000);
print "elapsed_ns=$elapsed checksum=$checksum warmup_checksum=$warmup_checksum\n";
