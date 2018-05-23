#!/usr/bin/env perl

sub shellsSort {
    my $n     = $#arr + 1;
    my $gap   = int($n/2);
    my $i     = 0;
    my $j     = 0;
    my $temp  = undef;
    
    while ($gap > 0) {
        $i = $gap;
        while ($i < $n) {
            $temp = $arr[$i];
            $j = $i;
            while ($j >= $gap && $arr[$j - $gap] > $temp) {
                $arr[$j] = $arr[$j - $gap];
                $j = $j - $gap;
            }
            $arr[$j] = $temp;
            $i = $i + 1;
        }
        $gap = int($gap/2);
    }
}

our @arr = (9, 8, 7, 6, 5, 4, 3, 2, 1, 0);

for (my $c=0; $c < 10000000; $c++) {
    shellsSort();
    @arr = (9, 8, 7, 6, 5, 4, 3, 2, 1, 0);
}

print "Perl global array and the cycle \"for\" \n";

1;