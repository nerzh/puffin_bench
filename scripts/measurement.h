#ifndef PUFFIN_MEASUREMENT_H
#define PUFFIN_MEASUREMENT_H
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <errno.h>

static int64_t benchmark_arg(int argc, char **argv, int index, int64_t fallback) {
    if (index >= argc) return fallback;
    char *end;
    errno = 0;
    long long value = strtoll(argv[index], &end, 10);
    if (errno || end == argv[index] || *end || value < 0 || value > 2147483647) {
        fprintf(stderr, "Arguments must be integers in 0..2147483647\n");
        exit(1);
    }
    return value;
}
static int64_t benchmark_now_ns(void) {
    struct timespec ts;
    if (clock_gettime(CLOCK_MONOTONIC, &ts)) { perror("clock_gettime"); exit(1); }
    return (int64_t)ts.tv_sec * 1000000000 + ts.tv_nsec;
}
#endif
