# smallest end to end test: arithmetic, loop, store, load, mul, call/return
    .section .text.init
    .globl _start
_start:
    li   x1, 5
    li   x2, 0
loop:
    add  x2, x2, x1
    addi x1, x1, -1
    bnez x1, loop
    la   x3, var
    sw   x2, 0(x3)
    lw   x4, 0(x3)
    addi x4, x4, 1
    mul  x5, x4, x4
    jal  x1, func
    la   x31, tohost
    li   x30, 1
    sw   x30, 0(x31)
halt:
    j    halt
func:
    addi x6, x5, 7
    ret

    .section .tohost, "aw", @progbits
    .align 3
    .globl tohost
tohost: .dword 0
    .globl fromhost
fromhost: .dword 0
    .data
var: .word 0
