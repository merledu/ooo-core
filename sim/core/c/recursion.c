// recursion (call/return prediction, stack loads and stores): fibonacci, ackermann, hanoi, gcd
static int fib(int n) { return n < 2 ? n : fib(n - 1) + fib(n - 2); }
static int ack(int m, int n) { return m == 0 ? n + 1 : (n == 0 ? ack(m - 1, 1) : ack(m - 1, ack(m, n - 1))); }
static int moves;
static void hanoi(int n, int from, int to, int via) {
    if (n == 0) return;
    hanoi(n - 1, from, via, to);
    moves++;
    hanoi(n - 1, via, to, from);
}
static unsigned gcd(unsigned a, unsigned b) { return b == 0 ? a : gcd(b, a % b); }

int main(void) {
    if (fib(13) != 233) return 1;
    if (ack(2, 3) != 9) return 2;
    hanoi(7, 0, 2, 1);
    if (moves != 127) return 3;
    if (gcd(1071, 462) != 21) return 4;
    if (gcd(0x7fffffff, 65536) != 1) return 5;
    return 0;
}
