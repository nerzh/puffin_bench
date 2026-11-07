#define _POSIX_C_SOURCE 200809L
#include "../../scripts/measurement.h"
#include <string.h>

static size_t run(int64_t iterations) {
    const char template[] = "test_text\n";
    const size_t line_size = sizeof(template) - 1;
    char *result = NULL;
    size_t size = 0;
    size_t capacity = 0;
    if ((uint64_t)iterations > SIZE_MAX / line_size) {
        fprintf(stderr, "Buffer size overflow\n");
        exit(1);
    }
    for (int64_t count = 0; count < iterations; count++) {
        size_t required = size + line_size;
        if (required > capacity) {
            size_t next = capacity == 0 ? 64 : capacity;
            while (next < required) {
                next = next > SIZE_MAX / 2 ? required : next * 2;
            }
            char *grown = realloc(result, next);
            if (!grown) { perror("realloc"); free(result); exit(1); }
            result = grown;
            capacity = next;
        }
        memcpy(result + size, template, line_size);
        size = required;
    }
    FILE *file = fopen("./store/c.txt", "wb");
    if (!file) { perror("fopen"); free(result); exit(1); }
    size_t written = 0;
    while (written < size) {
        size_t count = fwrite(result + written, 1, size - written, file);
        if (count == 0) {
            fprintf(stderr, "File write failed\n");
            fclose(file);
            free(result);
            exit(1);
        }
        written += count;
    }
    int status = fclose(file);
    free(result);
    if (status != 0) { perror("fclose"); exit(1); }
    return size;
}

int main(int argc, char **argv) {
    if (argc > 3) { fprintf(stderr, "lines [warmup_lines]\n"); return 1; }
    int64_t iterations = benchmark_arg(argc, argv, 1, 80000000);
    int64_t warmup = benchmark_arg(argc, argv, 2, 10000);
    size_t warmup_bytes = run(warmup);
    int64_t start = benchmark_now_ns();
    size_t bytes = run(iterations);
    int64_t elapsed = benchmark_now_ns() - start;
    printf("elapsed_ns=%lld bytes=%zu warmup_bytes=%zu\n",
           (long long)elapsed, bytes, warmup_bytes);
    return 0;
}
