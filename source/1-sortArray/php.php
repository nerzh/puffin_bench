#!/usr/bin/env php

<?php 

    function shellsSort(& $arr) {
      $n    = count($arr);
      $gap  = intval($n/2);
      $i    = 0;
      $j    = 0;
      $temp = NULL;
      
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
        $gap = intval($gap/2);
      }
    }

    $a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
    $c = 0;

    while ($c < 15000000) {
      shellsSort($a);
      $a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
      $c = $c + 1;
    }

    $version = phpversion();
    echo "PHP version: {$version}\n";

?>
