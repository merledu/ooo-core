OUTPUT_ARCH( "riscv" )
ENTRY(rvtest_entry_point)

/* one image at 0x80000000, loaded in the instruction memory and in the data memory of tb_core */
SECTIONS
{
  . = 0x80000000;
  .text.init : { *(.text.init) }
  . = ALIGN(0x1000);
  .tohost : { *(.tohost) }
  . = ALIGN(0x1000);
  .text : { *(.text) }
  . = ALIGN(0x1000);
  .data : { *(.data) }
  .data.string : { *(.data.string)}
  .bss : { *(.bss) }
  _end = .;
}
