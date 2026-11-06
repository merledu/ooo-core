// byte / halfword / word memory accesses: string and memory routines, bit fields, linked list, crc
typedef unsigned char u8; typedef unsigned short u16; typedef unsigned int u32;

static void *my_memcpy(void *d, const void *s, u32 n) { u8 *dd = d; const u8 *ss = s; while (n--) *dd++ = *ss++; return d; }
static void *my_memset(void *d, int c, u32 n) { u8 *dd = d; while (n--) *dd++ = (u8)c; return d; }
static u32 my_strlen(const char *s) { u32 n = 0; while (s[n]) n++; return n; }
static int my_strcmp(const char *a, const char *b) { while (*a && *a == *b) { a++; b++; } return (u8)*a - (u8)*b; }
static void reverse(char *s) { u32 n = my_strlen(s); for (u32 i = 0; i < n / 2; i++) { char t = s[i]; s[i] = s[n - 1 - i]; s[n - 1 - i] = t; } }

static u32 crc32(const u8 *p, u32 n) {
    u32 c = 0xffffffffu;
    while (n--) { c ^= *p++; for (int k = 0; k < 8; k++) c = (c >> 1) ^ (0xedb88320u & -(c & 1)); }
    return ~c;
}

struct node { struct node *next; short key; signed char tag; u8 flag; };
static struct node pool[16];
struct packed { u8 a; u16 b; u8 c; u32 d; signed char e; short f; } __attribute__((packed));

static char text[] = "The quick brown fox jumps over the lazy dog";
static char copy[64];
static u16 halves[8];

int main(void) {
    if (my_strlen(text) != 43) return 1;
    if (crc32((const u8 *)text, 43) != 0x414fa339u) return 2;
    my_memcpy(copy, text, 44);
    if (my_strcmp(copy, text) != 0) return 3;
    reverse(copy);
    if (copy[0] != 'g' || copy[42] != 'T' || my_strcmp(copy, text) <= 0) return 4;
    my_memset(copy + 3, 0x80, 5);
    if ((signed char)copy[4] != -128 || (u8)copy[7] != 0x80 || copy[8] == (char)0x80) return 5;

    // byte stores followed by wider loads of the same word and the other way round
    u32 w = 0;
    u8 *pb = (u8 *)&w;
    pb[0] = 0x11; pb[1] = 0x22; pb[2] = 0x33; pb[3] = 0x44;
    if (w != 0x44332211u) return 6;
    w = 0x89abcdefu;
    if (pb[0] != 0xef || pb[3] != 0x89 || *(u16 *)(pb + 2) != 0x89ab || *(short *)pb != (short)0xcdef) return 7;
    for (int i = 0; i < 8; i++) halves[i] = (u16)(0xf000 + i * 0x111);
    u32 hs = 0;
    for (int i = 0; i < 8; i++) hs += (short)halves[i];
    if (hs != 0xffff9ddcu) return 8;

    // linked list built and walked through pointers
    struct node *head = 0;
    for (int i = 0; i < 16; i++) { pool[i].key = (short)(i * 37 - 200); pool[i].tag = (signed char)(-i); pool[i].flag = (u8)(i * 17); pool[i].next = head; head = &pool[i]; }
    int ks = 0, ts = 0, fs = 0, n = 0;
    for (struct node *q = head; q; q = q->next) { ks += q->key; ts += q->tag; fs += q->flag; n++; }
    if (n != 16 || ks != 1240 || ts != -120 || fs != 2040) return 9;

    struct packed s;
    volatile struct packed *ps = &s;
    ps->a = 1; ps->b = 0xbeef; ps->c = 0xcc; ps->d = 0xdeadbeef; ps->e = -5; ps->f = -1234;
    if (ps->a != 1 || ps->b != 0xbeef || ps->c != 0xcc || ps->d != 0xdeadbeefu || ps->e != -5 || ps->f != -1234) return 10;
    return 0;
}
