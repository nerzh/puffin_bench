#!/usr/bin/env perl

sub shellsSort {
  my $n    = $#arr + 1;
  my $gap  = int($n/2);
  my $i    = 0;
  my $j    = 0;
  my $temp = undef;
  
  while ($gap > 0) {
    $i = $gap;
    while ($i < $n) {
      $temp = $arr[$i];
      $j    = $i;
      while ($j >= $gap && $arr[$j - $gap] > $temp) {
        $arr[$j] = $arr[$j - $gap];
        $j       = $j - $gap;
      }
      $arr[$j] = $temp;
      $i       = $i + 1;
    }
    $gap = int($gap/2);
  }
}

our @arr = (9, 8, 7, 6, 5, 4, 3, 2, 1, 0);
my $c   = 0;
my $c2  = 0;
my $i   = @ARGV[0] + 0;

while ($c < $i) {
  while ($c2 < 10) {
    $arr[$c2] = 9 - $c2;
    $c2 = $c2 + 1;
  }
  shellsSort();
  $c  = $c + 1;
  $c2 = 0;
}

1;