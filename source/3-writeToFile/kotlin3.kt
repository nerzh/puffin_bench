import java.io.ByteArrayOutputStream
import java.io.FileOutputStream

fun argument(args: Array<String>, index: Int, fallback: Long): Long {
    val value = if (args.size > index) args[index].toLong() else fallback
    require(value in 0L..2147483647L)
    return value
}
fun run(iterations: Long): Int {
    val template = "test_text\n".toByteArray(Charsets.UTF_8)
    val result = ByteArrayOutputStream()
    var count = 0L
    while (count < iterations) {
        result.write(template, 0, template.size)
        count = count + 1
    }
    FileOutputStream("./store/kotlin.txt").use { file ->
        result.writeTo(file)
    }
    return result.size()
}
fun main(args: Array<String>) {
    require(args.size <= 2)
    val iterations = argument(args, 0, 80000000)
    val warmup = argument(args, 1, 10000)
    val warmupBytes = run(warmup)
    val start = System.nanoTime()
    val bytes = run(iterations)
    val elapsed = System.nanoTime() - start
    println("elapsed_ns=$elapsed bytes=$bytes warmup_bytes=$warmupBytes")
}
