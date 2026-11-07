object SortArray {
def shellsSort(arr: Array[Long]): Unit = {
    var gap = arr.length / 2
    while (gap > 0) {
        var i = gap
        while (i < arr.length) {
            val temp = arr(i)
            var j = i
            while (j >= gap && arr(j - gap) > temp) {
                arr(j) = arr(j - gap)
                j = j - gap
            }
            arr(j) = temp
            i = i + 1
        }
        gap = gap / 2
    }
}
def run(arr: Array[Long], iterations: Long, seed: Long): Long = {
    var state = seed
    var checksum = 0L
    var c = 0L
    while (c < iterations) {
        var k = 0
        while (k < arr.length) {
            state = (state * 1664525L + 1013904223L) & 2147483647L
            arr(k) = (state >> 8) & 65535L
            k = k + 1
        }
        shellsSort(arr)
        k = 0
        while (k < arr.length) {
            checksum = (checksum * 31L + arr(k)) & 2147483647L
            k = k + 1
        }
        c = c + 1
    }
    return checksum
}
def argument(args: Array[String], index: Int, fallback: Long): Long = {
    val value = if (args.length > index) args(index).toLong else fallback
    require(value >= 0 && value <= 2147483647L)
    value
}
def main(args: Array[String]): Unit = {
    require(args.length >= 1 && args.length <= 3)
    val iterations = argument(args, 0, 0)
    val seed = argument(args, 1, 12345)
    val warmup = argument(args, 2, 10000)
    val arr = new Array[Long](100)
    val warmupChecksum = run(arr, warmup, seed)
    val start = System.nanoTime()
    val checksum = run(arr, iterations, seed)
    val elapsed = System.nanoTime() - start
    println(s"elapsed_ns=$elapsed checksum=$checksum warmup_checksum=$warmupChecksum")
}
}
