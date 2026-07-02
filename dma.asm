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
        DMASIZE 1                  — use 2-byte (halfword) transfers
        DMACPY $0400, $0800, 500   — copy 500 halfwords (1000 bytes)

*/

/*

    DMACPY src, dst, cnt
    Copy cnt units from src to dst using DMA.
    Addresses are 16-bit and zero-extended to 32-bit internally.
    The transfer size (byte/halfword/word) is set by DMASIZE (default 0 = byte).

    Example: DMACPY $0400, $0800, 1000  — copy 1000 bytes screen to $0800

*/
DmaCpyCmd:
    jsr Get16Bit                // source address → $14 (lo), $15 (hi)
    lda $14
    sta DMA_READ_ADDR
    lda $15
    sta DMA_READ_ADDR + 1
    lda #0                      // Upper 16 bits of 32-bit address = 0
    sta DMA_READ_ADDR + 2
    sta DMA_READ_ADDR + 3

    jsr basic.CHKCOM

    jsr Get16Bit                // destination address → $14/$15
    lda $14
    sta DMA_WRITE_ADDR
    lda $15
    sta DMA_WRITE_ADDR + 1
    lda #0
    sta DMA_WRITE_ADDR + 2
    sta DMA_WRITE_ADDR + 3

    jsr basic.CHKCOM

    jsr Get16Bit                // transfer count → $14/$15
    lda $14
    sta DMA_COUNT_LO
    lda $15
    sta DMA_COUNT_HI

    lda #1                      // Start the DMA transfer
    sta DMA_CTRL

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
DmaSizeCmd:
    jsr Get8Bit                 // size → Y
    tya
    sta DMA_SIZE
    rts

/*

    DMAINCR rinc, winc
    Set whether the source and destination addresses auto-increment after
    each DMA transfer:
        0 = fixed address (useful for fills from/to a single location)
        1 = increment address after each transfer (normal block copy)

    Note: DMACPY always sets both increments to 1.  Use DMAINCR before a
    POKE-based DMA setup when you need a non-incrementing address, e.g.
    to fill a region by reading the same source byte repeatedly.

    Example: DMAINCR 0, 1  — fixed source, incrementing dest (memory fill)
             DMAINCR 1, 1  — both increment (normal copy, same as DMACPY)
             DMAINCR 1, 0  — incrementing source, fixed dest (stream to port)

*/
DmaIncrCmd:
    jsr Get8Bit                 // rinc (0 or 1) → Y
    tya
    sta DMA_READ_INC
    jsr basic.CHKCOM
    jsr Get8Bit                 // winc (0 or 1) → Y
    tya
    sta DMA_WRITE_INC
    rts
