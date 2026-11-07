#define _POSIX_C_SOURCE 200809L
#include "../../scripts/measurement.h"

static void shells_sort(int64_t *arr, int64_t count) {
    int64_t gap = count / 2;
    while (gap > 0) {
        int64_t i = gap;
        while (i < count) {
            int64_t temp = arr[i];
            int64_t j = i;
            while (j >= gap && arr[j - gap] > temp) {
                arr[j] = arr[j - gap];
                j = j - gap;
            }
            arr[j] = temp;
            i = i + 1;
        }
        gap = gap / 2;
    }
}

static int64_t run(int64_t *arr, int64_t count, int64_t iterations, int64_t seed) {
    int64_t state = seed;
    int64_t checksum = 0;
    int64_t c = 0;
    while (c < iterations) {
        int64_t k = 0;
        while (k < count) {
            state = (state * 1664525 + 1013904223) & 2147483647;
            arr[k] = (state >> 8) & 65535;
            k = k + 1;
        }
        shells_sort(arr, count);
        k = 0;
        while (k < count) {
            checksum = (checksum * 31 + arr[k]) & 2147483647;
            k = k + 1;
        }
        c = c + 1;
    }
    return checksum;
}

int main(int argc, char **argv) {
    if (argc < 2 || argc > 4) return 1;
    int64_t iterations = benchmark_arg(argc, argv, 1, 0);
    int64_t seed = benchmark_arg(argc, argv, 2, 12345);
    int64_t warmup = benchmark_arg(argc, argv, 3, 10000);
    int64_t arr[100] = {0};
    const int64_t count = sizeof(arr) / sizeof(arr[0]);
    int64_t warmup_checksum = run(arr, count, warmup, seed);
    int64_t start = benchmark_now_ns();
    int64_t checksum = run(arr, count, iterations, seed);
    int64_t elapsed = benchmark_now_ns() - start;
    printf("elapsed_ns=%lld checksum=%lld warmup_checksum=%lld\n",
           (long long)elapsed, (long long)checksum, (long long)warmup_checksum);
    return 0;
}
