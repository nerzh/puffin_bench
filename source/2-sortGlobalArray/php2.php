<?php
final class Sorter {
    public $arr;
    function __construct() { $this->arr = array_fill(0, 100, 0); }
function shellsSort() {
    $gap = intdiv(count($this->arr), 2);
    while ($gap > 0) {
        $i = $gap;
        while ($i < count($this->arr)) {
            $temp = $this->arr[$i];
            $j = $i;
            while ($j >= $gap && $this->arr[$j - $gap] > $temp) {
                $this->arr[$j] = $this->arr[$j - $gap];
                $j = $j - $gap;
            }
            $this->arr[$j] = $temp;
            $i = $i + 1;
        }
        $gap = intdiv($gap, 2);
    }
}
function run($iterations, $seed) {
    $state = $seed;
    $checksum = 0;
    $c = 0;
    while ($c < $iterations) {
        $k = 0;
        while ($k < count($this->arr)) {
            $state = ($state * 1664525 + 1013904223) & 2147483647;
            $this->arr[$k] = ($state >> 8) & 65535;
            $k = $k + 1;
        }
        $this->shellsSort();
        $k = 0;
        while ($k < count($this->arr)) {
            $checksum = ($checksum * 31 + $this->arr[$k]) & 2147483647;
            $k = $k + 1;
        }
        $c = $c + 1;
    }
    return $checksum;
}
}
function argument($index, $fallback) {
    global $argv;
    if (!isset($argv[$index])) return $fallback;
    $value = filter_var($argv[$index], FILTER_VALIDATE_INT);
    if ($value === false || $value < 0 || $value > 2147483647) throw new Exception('Invalid argument');
    return $value;
}
if ($argc < 2 || $argc > 4) throw new Exception('iterations [seed [warmup]]');
$iterations = argument(1, 0);
$seed = argument(2, 12345);
$warmup = argument(3, 10000);
$sorter = new Sorter();
$warmupChecksum = $sorter->run($warmup, $seed);
$start = hrtime(true);
$checksum = $sorter->run($iterations, $seed);
$elapsed = hrtime(true) - $start;
echo "elapsed_ns=$elapsed checksum=$checksum warmup_checksum=$warmupChecksum\n";
