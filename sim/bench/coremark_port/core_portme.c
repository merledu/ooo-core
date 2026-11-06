/* CoreMark port for the bare metal core. start_time()/stop_time() write a marker word:
   the testbench logs the cycle of every memory write, run_bench.py takes the cycles in between. */
#include "coremark.h"

volatile ee_s32 seed1_volatile = 0x0;
volatile ee_s32 seed2_volatile = 0x0;
volatile ee_s32 seed3_volatile = 0x66;
volatile ee_s32 seed4_volatile = ITERATIONS;
volatile ee_s32 seed5_volatile = 0;

volatile ee_u32 bench_marker;      /* 1: timed part starts, 2: timed part ends */
extern volatile ee_u32 tohost;

ee_u32 default_num_contexts = 1;

void start_time(void) { bench_marker = 1; }
void stop_time(void)  { bench_marker = 2; }
CORE_TICKS get_time(void) { return 0; }
secs_ret time_in_secs(CORE_TICKS ticks) { (void)ticks; return 0; }

void portable_init(core_portable *p, int *argc, char *argv[]) { (void)argc; (void)argv; p->portable_id = 1; }
void portable_fini(core_portable *p) { p->portable_id = 0; }

/* no console: a wrong result reported by CoreMark ("[0]ERROR! ... crc ...", "Cannot validate operation ...") ends the
   run with exit code 1. The "must execute for at least 10 secs" error (and the "Errors detected" line it causes) is
   ignored: there is no timer, the testbench counts the clock cycles. */
int ee_printf(const char *fmt, ...)
{
    if ((fmt[0] == '[' && fmt[4] == 'E' && fmt[5] == 'R' && fmt[6] == 'R') ||
        (fmt[0] == 'C' && fmt[1] == 'a' && fmt[2] == 'n' && fmt[3] == 'n' && fmt[4] == 'o' && fmt[5] == 't')) {
        tohost = (1 << 1) | 1;
        for (;;) ;
    }
    return 0;
}
