#!/usr/bin/env kscript
import java.time.LocalDateTime

fun shellsSort(arr: Array<Int>) {
  var n    : Int  = arr.count()
  var gap  : Int  = n/2
  var i    : Int  = 0
  var j    : Int  = 0
  var temp : Int? = null

  while (gap > 0) {
    i = gap
    while (i < n) {
      temp = arr[i]
      j    = i
      while (j >= gap && arr[j - gap] > temp) {
        arr[j] = arr[j - gap]
        j      = j - gap
      }
      arr[j] = temp
      i      = i + 1
    }
    gap = gap/2
  }
}

var arr : Array<Int> = arrayOf(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
var c   : Int        = 0
var c2  : Int        = 0

var current = LocalDateTime.now()
println("Current Date and Time is: $current")

while (c < 15000000) {
    while (c2 < 10) {
        arr[c2] = 9 - c2
        c2 = c2 + 1
    }
    shellsSort(arr)
    c  = c + 1
    c2 = 0
}

current = LocalDateTime.now()
println("Current Date and Time is: $current")

println("Kotlin")
