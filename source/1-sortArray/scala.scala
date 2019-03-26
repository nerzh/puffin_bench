
object SortArray {
  // PAYLOAD
  def shellsSort(arr: Array[Int]) {
      val n    : Int = arr.length
      var gap  : Int = n/2
      var i    : Int = 0
      var j    : Int = 0
      var temp : Int = 0
      
      while (gap > 0) {
          i = gap
          while (i < n) {
              temp = arr(i)
              j    = i
              while (j >= gap && arr(j - gap) > temp) {
                  arr(j) = arr(j - gap)
                  j      = j - gap
              }
              arr(j) = temp
              i      = i + 1
          }
          gap = gap/2
      }
  }

  // TEST
  def main(args: Array[String]): Unit = {
    var arr  : Array[Int] = new Array[Int](10)
    var c    : Int   = 0
    var c2   : Int   = 0
    // var i    : Int   = args(0).toInt

    while (c < 25000000) {
        while (c2 < 10) {
            arr(c2) = 9 - c2
            c2 = c2 + 1
        }
        shellsSort(arr)
        c  = c + 1
        c2 = 0
    }

    // println("Scala sort array\n")
  }
}




