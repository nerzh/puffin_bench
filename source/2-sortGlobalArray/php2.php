#!/usr/bin/env php

<?php 
    
  function shellsSort() {
    $n    = count($GLOBALS["a"]);
    $gap  = intval($n/2);
    $i    = 0;
    $j    = 0;
    $temp = NULL;
    
    while ($gap > 0) {
      $i = $gap;
      while ($i < $n) {
        $temp = $GLOBALS["a"][$i];
        $j    = $i;
        while ($j >= $gap && $GLOBALS["a"][$j - $gap] > $temp) {
          $GLOBALS["a"][$j] = $GLOBALS["a"][$j - $gap];
          $j                = $j - $gap;
        }
        $GLOBALS["a"][$j] = $temp;
        $i                = $i + 1;
      }
      $gap = intval($gap/2);
    }
  }

  $a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
  $c = 0;

  while ($c < 15000000) {
    shellsSort();
    $a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
    $c = $c + 1;
  }

  echo "PHP sort global array\n";
  $version = phpversion();
  echo "PHP version: {$version}\n";

?>
