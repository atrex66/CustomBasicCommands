/*

    DMA Commands — DMACPY, DMASIZE
    ────────────────────────────────
    DMA channel 11, reserved for the 6502 emulator.
    Transfers operate within RP2350 SRAM and are non-blocking — the 6502
    continues executing while the DMA is active.

    Addresses are 16-bit (zero-extended to 32-bit), matching the emulated
    C64 address space. Byte-transfers with auto-increment are the default.

    Typical usage:
        DMACPY $0400, $0800, 1000  — copy 1000 bytes from $0400 to $0800

    To change transfer width first:
        DMACPY $0400, $0800, 500   — copy 500 halfwords (1000 bytes)

*/

DmaCommon:
    jsr Get16Bit                // Get the source address (16-bit) into $14/$15
    lda $14
    sta r0L
    lda $15
    sta r0H
    jsr basic.CHKCOM
    jsr Get16Bit                // Get the destination address (16-bit) into $14/$15
    lda $14
    sta r1L
    lda $15
    sta r1H
    jsr basic.CHKCOM
    jsr Get16Bit                // Get the transfer count (16-bit) into $14/$15
    lda $14
    sta r2L
    lda $15
    sta r2H
    ldx r2L                       // Load low byte of transfer count into X
    ldy r2H                       // Load high byte of transfer count into Y
    SysCall(DMA_SET_TRANSFER_COUNT) // Set the transfer count for DMA
    ldx r0L                       // Load low byte of source address into X
    ldy r0H                       // Load high byte of source address into Y
    SysCall(DMA_SET_SRC)          // Set the source address for DMA
    ldx r1L                       // Load low byte of destination address into X
    ldy r1H                       // Load high byte of destination address into Y
    lda #$00
    SysCall(DMA_SET_DST)          // Set the destination address for DMA
    rts

/*

    DMACPY src, dst, cnt
    Copy cnt units from src to dst using DMA.
    Addresses are 16-bit and zero-extended to 32-bit internally.
    The transfer size (byte/halfword/word) is set by DMASIZE (default 0 = byte).

    Example: DMACPY $0400, $0800, 1000  — copy 1000 bytes screen to $0800

*/
DmaCpyCmd:
    jsr DmaCommon
    ldx #$01
    ldy #$01
    SysCall(DMA_SET_INCREMENT)    // Set source and destination increment to 1
    SysCall(DMA_START)            // Start the DMA transfer
    SysCall(DMA_WAIT_COMPLETE)    // Wait for the DMA transfer to complete
    rts

/*
    DMASIZE n
    Set the DMA transfer width for subsequent DMACPY calls:
        0 = byte (8-bit)
        1 = halfword (16-bit)
        2 = word (32-bit)

    Example: DMASIZE 0  — byte transfers (default)
             DMASIZE 2  — word transfers
*/

DmaFillCmd:
    jsr DmaCommon
    SysCall(DMA_SET_DST)          // Set the destination address for DMA
    ldx #$00
    ldy #$01
    SysCall(DMA_SET_INCREMENT)    // Set source and destination increment to 1
    SysCall(DMA_START)            // Start the DMA transfer
    SysCall(DMA_WAIT_COMPLETE)    // Wait for the DMA transfer to complete
    rts

