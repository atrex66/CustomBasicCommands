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

    Trashes: A, X

*/
SetGPIOBit:
    lda r0L      
    ldx r1L      
    SysCall(GPIO_SET_PINMODE)
    rts

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
    jsr SetGPIOBit
    rts


SetPinOut:
    lda r0L      
    ldx r1L      
    SysCall(GPIO_SET_PINOUT)
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
    jsr SetPinOut
    rts

PinPullOut:
    lda r0L      
    ldx r1L      
    SysCall(GPIO_SET_PINPULL)
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
    jsr PinPullOut
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
    SysCall(GPIO_GET_PINSTATE)  // Read GPIO_STATE register into A/X
    sta $63
    lda #$00
    sta $62
    ldx #$90
    sec
    jmp $bc49
