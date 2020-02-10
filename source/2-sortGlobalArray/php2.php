#!/usr/bin/env php

<?php 
    
  function shellsSort() {
    $n    = count($GLOBALS["arr"]);
    $gap  = intval($n/2);
    $i    = 0;
    $j    = 0;
    $temp = NULL;
    
    while ($gap > 0) {
      $i = $gap;
      while ($i < $n) {
        $temp = $GLOBALS["arr"][$i];
        $j    = $i;
        while ($j >= $gap && $GLOBALS["arr"][$j - $gap] > $temp) {
          $GLOBALS["arr"][$j] = $GLOBALS["arr"][$j - $gap];
          $j                = $j - $gap;
        }
        $GLOBALS["arr"][$j] = $temp;
        $i                = $i + 1;
      }
      $gap = intval($gap/2);
    }
  }

  $arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  $c   = 0;
  $c2  = 0;
  $i   = $argv[1];

  while ($c < $i) {
    while ($c2 < 10) {
      $arr[$c2] = 9 - $c2;
      $c2 = $c2 + 1;
    }
    shellsSort();
    $c  = $c + 1;
    $c2 = 0;
  }

//  $version = phpversion();
//  echo "version: {$version}\n";

?>
