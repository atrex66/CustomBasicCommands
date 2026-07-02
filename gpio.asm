/*

    GPIO Commands — PINMODE, PINOUT, PINPULL
    ─────────────────────────────────────────
    All three commands work identically: read one pin number and one value
    (0/1), then set or clear the corresponding bit in a 4-byte RP2350
    register using the shared SetGPIOBit subroutine.

    Hardware registers (all little-endian 32-bit bitmasks):
        GPIO_DIRECTION  $D033  — direction   (1 = output)
        GPIO_STATE      $D02F  — output level (1 = HIGH)
        GPIO_PULLUP     $D037  — pull-up      (1 = enabled)

*/

/*

    Set or clear a single bit in a 4-byte GPIO register.

    Inputs:
        r0L = pin number (0-29)
        r1L = value: 0 = clear bit, non-zero = set bit
        r4  = base address of the 4-byte register (low byte in r4L, high in r4H)

    Trashes: A, X, Y

*/
SetGPIOBit:
    lda r0L                     // Compute byte offset = pin >> 3
    lsr
    lsr
    lsr
    clc
    adc r4L                     // Add to base address low byte
    sta r4L
    lda #0
    adc r4H                     // Propagate carry into high byte
    sta r4H

    lda r0L                     // Bit position within byte = pin & 7
    and #$07
    tax
    lda GpioBitMask, x          // Get the bit mask (1 << bit-position)

    ldy #0
    ldx r1L                     // Is value == 0?
    beq !clear+
    ora (r4), y                 // SET: or the bit in
    jmp !done+
!clear:
    eor #$ff                    // CLEAR: invert mask and AND it out
    and (r4), y
!done:
    sta (r4), y
    rts

GpioBitMask:
    .byte %00000001
    .byte %00000010
    .byte %00000100
    .byte %00001000
    .byte %00010000
    .byte %00100000
    .byte %01000000
    .byte %10000000

/*

    PINMODE pin, dir
    Set a GPIO pin's direction: 0 = input, 1 = output.

    Example: PINMODE 25, 1  — set GP25 (onboard LED) as output

*/
PinModeCmd:
    jsr Get8Bit                 // pin number → Y
    sty r0L
    jsr basic.CHKCOM
    jsr Get8Bit                 // direction → Y
    sty r1L
    lda #<GPIO_DIRECTION        // Point r4 at GPIO_DIRECTION base
    sta r4L
    lda #>GPIO_DIRECTION
    sta r4H
    jsr SetGPIOBit
    rts

/*

    PINOUT pin, val
    Drive a GPIO pin high (1) or low (0).

    Example: PINOUT 25, 1  — LED on
             PINOUT 25, 0  — LED off

*/
PinOutCmd:
    jsr Get8Bit
    sty r0L
    jsr basic.CHKCOM
    jsr Get8Bit
    sty r1L
    lda #<GPIO_STATE
    sta r4L
    lda #>GPIO_STATE
    sta r4H
    jsr SetGPIOBit
    rts

/*

    PINPULL pin, val
    Enable (1) or disable (0) the internal pull-up on a GPIO pin.

    Example: PINPULL 10, 1  — enable pull-up on GP10

*/
PinPullCmd:
    jsr Get8Bit
    sty r0L
    jsr basic.CHKCOM
    jsr Get8Bit
    sty r1L
    lda #<GPIO_PULLUP
    sta r4L
    lda #>GPIO_PULLUP
    sta r4H
    jsr SetGPIOBit
    rts

/*

    PINGET(pin)
    Read the current state of a GPIO pin. Returns 1 if the pin is HIGH,
    0 if it is LOW. Reads the output latch (GPIO_STATE) for output pins,
    or the actual level for input pins if the C-side also maps GPIO_INPUT.

    Example: A = PINGET(25)    — read onboard LED state
             IF PINGET(10) THEN PRINT "HIGH"

*/
PinGetFun:
    jsr basic.GETADR            // Convert FAC (already evaluated by PARCHK) → $14/$15
    lda $14                     // Pin number (0-29) in low byte

    // Byte offset = pin >> 3; add to GPIO_STATE base address
    lsr
    lsr
    lsr
    clc
    adc #<GPIO_STATE
    sta r4L
    lda #>GPIO_STATE
    adc #0
    sta r4H

    lda $14                     // Bit position = pin & 7
    and #$07
    tax

    ldy #0
    lda (r4), y                 // Read the byte containing this pin's bit

    // Shift right X times so the target bit lands in bit 0
    cpx #0
    beq !done+
!shift:
    lsr
    dex
    bne !shift-
!done:
    and #$01                    // Isolate the bit → 0 or 1

    // Write result into FAC (integer 0 or 1)
    sta $63
    lda #$00
    sta $62
    ldx #$90
    sec
    jmp $bc49
