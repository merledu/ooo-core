/* Replacement of the riscv-tests util.h for the bare metal core (no CSRs, no console).
   setStats() writes a marker word, the testbench provides the cycle of every memory write. */
#ifndef BENCH_UTIL_H
#define BENCH_UTIL_H

extern volatile unsigned int bench_marker;   /* 1: timed part starts, 2: timed part ends */
extern unsigned long bench_fake_time;

#define setStats(on)     (bench_marker = (on) ? 1 : 2)
/* Dhrystone only needs "enough time passed" to accept the run */
#define read_csr(reg)    (bench_fake_time += 10 * HZ)
#define printf(...)      ((void)0)

char *strcpy(char *dst, const char *src);
int   strcmp(const char *a, const char *b);
void *memcpy(void *dst, const void *src, unsigned int n);
void *memset(void *dst, int c, unsigned int n);

#endif
