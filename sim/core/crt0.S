# start up code of the C tests: set the stack, call main, report its return value to tohost
    .section .text.init
    .globl _start
_start:
    la   sp, _stack_top
    call main
    # tohost = (return value << 1) | 1  (HTIF exit, also stops tb_core)
    slli a0, a0, 1
    ori  a0, a0, 1
    la   t0, tohost
    sw   a0, 0(t0)
1:  j    1b

    .section .tohost, "aw", @progbits
    .align 3
    .globl tohost
tohost:   .dword 0
    .globl fromhost
fromhost: .dword 0
