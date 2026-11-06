/* Memory map of tb_core: 256 KB image at 0x80000000 (text first, data from +64 KB, stack at the top) */
OUTPUT_ARCH(riscv)
ENTRY(_start)
SECTIONS
{
    . = 0x80000000;
    .text : { *(.text.init) *(.text*) }
    . = 0x80010000;
    .data : { *(.tohost) *(.rodata*) *(.srodata*) *(.data*) *(.sdata*) *(.sbss*) *(.bss*) *(COMMON) }
    _end = .;
    _stack_top = 0x80040000;
}
