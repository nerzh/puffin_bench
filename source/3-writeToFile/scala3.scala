import java.io.{ByteArrayOutputStream, FileOutputStream}
import java.nio.charset.StandardCharsets

object WriteToFile {
    def argument(args: Array[String], index: Int, fallback: Long): Long = {
        val value = if (args.length > index) args(index).toLong else fallback
        require(value >= 0 && value <= 2147483647L)
        value
    }
    def run(iterations: Long): Int = {
        val template = "test_text\n".getBytes(StandardCharsets.UTF_8)
        val result = new ByteArrayOutputStream()
        var count = 0L
        while (count < iterations) {
            result.write(template, 0, template.length)
            count = count + 1
        }
        val file = new FileOutputStream("./store/scala.txt")
        try {
            result.writeTo(file)
        } finally {
            file.close()
        }
        result.size()
    }
    def main(args: Array[String]): Unit = {
        require(args.length <= 2)
        val iterations = argument(args, 0, 80000000)
        val warmup = argument(args, 1, 10000)
        val warmupBytes = run(warmup)
        val start = System.nanoTime()
        val bytes = run(iterations)
        val elapsed = System.nanoTime() - start
        println(s"elapsed_ns=$elapsed bytes=$bytes warmup_bytes=$warmupBytes")
    }
}
