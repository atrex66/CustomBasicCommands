#importonce

// ─────────────────────────────────────────────────────────────────────────────
// RP2350 Memory-Mapped Peripheral Registers (C64+ / Pico 2)
// All addresses within the $D000–$DFFF I/O area.
// See MEMMAP.md for full descriptions and BASIC examples.
// ─────────────────────────────────────────────────────────────────────--------

// The memory-mapped devices have been removed and instead implemented via SysCall
// The SysCall numbers are defined in labels.asm
// with a simple SySCall() macro to call arm code from the 6502 VM
// the functions are implemented in syscalls.c and relative easy to extend with new functionality
// with the SysCall you can utilise the full speed of the RP2350 and its peripherals, without the overhead of the 6502 emulation
