// control flow: switch (jump table), function pointers (indirect calls), state machine, nested loops, collatz
typedef int (*fn)(int, int);
static int f_add(int a, int b) { return a + b; }
static int f_sub(int a, int b) { return a - b; }
static int f_xor(int a, int b) { return a ^ b; }
static int f_shl(int a, int b) { return a << (b & 7); }
static int f_min(int a, int b) { return a < b ? a : b; }
static fn table[5] = { f_add, f_sub, f_xor, f_shl, f_min };

static int classify(int x) {
    switch (x & 15) {
        case 0: return 11;  case 1: return 7;   case 2: return x + 1; case 3: return x * 3;
        case 4: return -x;  case 5: return 99;  case 6: return x >> 1; case 7: return x ^ 0x55;
        case 8: return 1;   case 9: return 2;   case 10: return 3;    case 11: return 5;
        case 12: return 8;  case 13: return 13; case 14: return 21;   default: return 34;
    }
}

static int collatz(unsigned n) { int steps = 0; while (n != 1) { n = (n & 1) ? 3 * n + 1 : n >> 1; steps++; } return steps; }

int main(void) {
    int acc = 0;
    for (int i = 0; i < 200; i++) acc = table[(unsigned)(acc + i) % 5](acc, i * 3 + 1);
    int cls = 0;
    for (int i = 0; i < 100; i++) cls += classify(i * 7 + (cls & 3));
    int st = 0, trans = 0;
    for (int i = 0; i < 300; i++) {
        switch (st) {
            case 0: st = (i & 1) ? 1 : 2; break;
            case 1: st = (i % 3 == 0) ? 3 : 0; break;
            case 2: st = (i % 5 == 0) ? 0 : 3; break;
            default: st = (i & 4) ? 1 : 0; break;
        }
        trans += st;
    }
    int tri = 0;
    for (int i = 0; i < 20; i++) for (int j = 0; j <= i; j++) { if ((i ^ j) & 1) continue; if (j > 15) break; tri += i - j; }
    if (collatz(27) != 111) return 1;
    // the same computation is done by Spike, the commit trace comparison checks every value
    return (acc ^ cls ^ trans ^ tri) == 0x7fffffff;
}
