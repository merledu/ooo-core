// multiplication / division: matrix product, 64 bit arithmetic, number formatting, primes
static int A[5][5], B[5][5], C[5][5];
static char buf[16];

static int itoa10(int v, char *s) {
    char t[12]; int n = 0, len = 0; unsigned u = v < 0 ? -(unsigned)v : (unsigned)v;
    do { t[n++] = '0' + u % 10; u /= 10; } while (u);
    if (v < 0) s[len++] = '-';
    while (n) s[len++] = t[--n];
    s[len] = 0;
    return len;
}

static int is_prime(unsigned n) {
    if (n < 2) return 0;
    for (unsigned d = 2; d * d <= n; d++) if (n % d == 0) return 0;
    return 1;
}

int main(void) {
    for (int i = 0; i < 5; i++) for (int j = 0; j < 5; j++) { A[i][j] = i * 7 - j * 3 + 1; B[i][j] = (i + 2) * (j - 3); }
    for (int i = 0; i < 5; i++) for (int j = 0; j < 5; j++) { int s = 0; for (int k = 0; k < 5; k++) s += A[i][k] * B[k][j]; C[i][j] = s; }
    int tr = 0;
    for (int i = 0; i < 5; i++) tr += C[i][i];
    if (tr != 650) return 1;

    volatile long long x = 0x123456789LL, y = -987654321LL;
    long long p = x * y;
    if (p != -4826388488949218745LL) return 2;
    volatile unsigned long long ux = 0xfedcba9876543210ULL;
    volatile unsigned uy = 0x12345;
    if (ux / uy != 0xe0004fa01c4dULL) return 3;
    if (ux % uy != 0x10a4fULL) return 4;
    volatile int m = -2147483647 - 1, mo = -1, z = 0;
    if (m / 7 != -306783378 || m % 7 != -2) return 5;
    if ((unsigned)m / 3u != 715827882u) return 6;
    (void)mo; (void)z;

    if (itoa10(-2147483647, buf) != 11 || buf[0] != '-' || buf[10] != '7') return 7;
    int count = 0;
    for (unsigned n = 0; n < 200; n++) count += is_prime(n);
    if (count != 46) return 8;
    return 0;
}
