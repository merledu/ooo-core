/* Support code of the Dhrystone port: marker, C library routines used by the benchmark */
volatile unsigned int bench_marker;
unsigned long bench_fake_time;

char *strcpy(char *dst, const char *src)
{
    char *d = dst;
    while ((*d++ = *src++) != 0) ;
    return dst;
}

int strcmp(const char *a, const char *b)
{
    while (*a && *a == *b) { a++; b++; }
    return (unsigned char)*a - (unsigned char)*b;
}

void *memcpy(void *dst, const void *src, unsigned int n)
{
    unsigned char *d = dst;
    const unsigned char *s = src;
    if ((((unsigned int)d | (unsigned int)s) & 3) == 0) {
        unsigned int *dw = (unsigned int *)d;
        const unsigned int *sw = (const unsigned int *)s;
        while (n >= 4) { *dw++ = *sw++; n -= 4; }
        d = (unsigned char *)dw; s = (const unsigned char *)sw;
    }
    while (n--) *d++ = *s++;
    return dst;
}

void *memset(void *dst, int c, unsigned int n)
{
    unsigned char *d = dst;
    while (n--) *d++ = (unsigned char)c;
    return dst;
}
