/*
 * GNU LD Linker Script for CMSIS Flash Algorithms
 *
 * A flash algorithm is a position-independent executables loaded by a
 * debug probe (e.g. probe-rs, OpenOCD, J-Link) into the target's RAM.
 * The loader is responsible for allocating the stack.
 * The symbols named * with KEEP are the ABI.
 *
 * Usage
 * -----
 *   arm-none-eabi-gcc ... -T flash_algo.ld -o flash_algo.elf
 */

SECTIONS {
    PrgCode ALIGN(4) : {
        /* CMSIS-mandated entry points */
        KEEP(*(.text.Init))
        KEEP(*(.text.UnInit))
        KEEP(*(.text.EraseSector))
        KEEP(*(.text.ProgramPage))
        KEEP(*(.text.EraseChip))    /* optional */
        KEEP(*(.text.BlankCheck))   /* optional */
        KEEP(*(.text.Verify))       /* optional */
        *(.text)
        *(.text.*)
        KEEP(*(.rodata.FlashDevice))  /* required in the ELF, but not needed on-device */
        *(.rodata)
        *(.rodata.*)
    }
    PrgData ALIGN(4) : {
        *(.data)
        *(.data.*)
        *(.bss)
        *(.bss.*)
        *(COMMON)
    }
}
