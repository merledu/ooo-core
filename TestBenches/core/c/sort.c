// bubble sort, insertion sort and a checksum over the result
static unsigned int seed = 12345;
static unsigned int rnd(void) { seed = seed * 1103515245u + 12345u; return (seed >> 8) & 0xffff; }

static void bubble(int *a, int n) {
    for (int i = 0; i < n - 1; i++)
        for (int j = 0; j < n - 1 - i; j++)
            if (a[j] > a[j + 1]) { int t = a[j]; a[j] = a[j + 1]; a[j + 1] = t; }
}

static void insertion(short *a, int n) {
    for (int i = 1; i < n; i++) {
        short k = a[i];
        int j = i - 1;
        while (j >= 0 && a[j] > k) { a[j + 1] = a[j]; j--; }
        a[j + 1] = k;
    }
}

int a[48];
short b[40];

int main(void) {
    for (int i = 0; i < 48; i++) a[i] = (int)rnd() - 30000;
    for (int i = 0; i < 40; i++) b[i] = (short)(rnd() - 20000);
    bubble(a, 48);
    insertion(b, 40);
    for (int i = 1; i < 48; i++) if (a[i - 1] > a[i]) return 1;
    for (int i = 1; i < 40; i++) if (b[i - 1] > b[i]) return 2;
    unsigned int sum = 0;
    for (int i = 0; i < 48; i++) sum = sum * 31 + (unsigned int)a[i];
    for (int i = 0; i < 40; i++) sum = sum * 31 + (unsigned int)b[i];
    return sum == 0;   // 0 = pass
}
