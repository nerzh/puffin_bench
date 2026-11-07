fun shellsSort(arr: LongArray) {
    var gap = arr.size / 2
    while (gap > 0) {
        var i = gap
        while (i < arr.size) {
            val temp = arr[i]
            var j = i
            while (j >= gap && arr[j - gap] > temp) {
                arr[j] = arr[j - gap]
                j = j - gap
            }
            arr[j] = temp
            i = i + 1
        }
        gap = gap / 2
    }
}
fun run(arr: LongArray, iterations: Long, seed: Long): Long {
    var state = seed
    var checksum = 0L
    var c = 0L
    while (c < iterations) {
        var k = 0
        while (k < arr.size) {
            state = (state * 1664525L + 1013904223L) and 2147483647L
            arr[k] = (state shr 8) and 65535L
            k = k + 1
        }
        shellsSort(arr)
        k = 0
        while (k < arr.size) {
            checksum = (checksum * 31L + arr[k]) and 2147483647L
            k = k + 1
        }
        c = c + 1
    }
    return checksum
}
fun argument(args: Array<String>, index: Int, fallback: Long): Long {
    val value = if (args.size > index) args[index].toLong() else fallback
    require(value in 0L..2147483647L)
    return value
}
fun main(args: Array<String>) {
    require(args.size in 1..3)
    val iterations = argument(args, 0, 0)
    val seed = argument(args, 1, 12345)
    val warmup = argument(args, 2, 10000)
    val arr = LongArray(100)
    val warmupChecksum = run(arr, warmup, seed)
    val start = System.nanoTime()
    val checksum = run(arr, iterations, seed)
    val elapsed = System.nanoTime() - start
    println("elapsed_ns=$elapsed checksum=$checksum warmup_checksum=$warmupChecksum")
}
