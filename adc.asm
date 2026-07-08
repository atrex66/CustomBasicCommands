
AdcFun:
    jsr basic.GETADR            // Convert FAC (already evaluated by PARCHK) → $14/$15
    lda $14                     // Pin number (0-3) in low byte
    SysCall(ADC_READ)           // Read ADC value into A/X
    cmp #$00
    bne illegal
    stx $63
    lda #$00
    sty $62
    ldx #$90
    sec
    jmp $bc49
illegal:
    jmp $b248

AdcInitFun:
    SysCall(ADC_INIT)           // Initialize the ADC hardware
    rts