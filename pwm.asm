/*

    PWM Commands — PWMSEL, PWMLVL, PWMWRP, PWMON, PWMOFF
    ───────────────────────────────────────────────────────
    The RP2350 has 12 PWM slices, each with two channels (A and B).
    GPIO pin ↔ slice map:
        Slice 0: A=GP0,  B=GP1   Slice 6:  A=GP12, B=GP13
        Slice 1: A=GP2,  B=GP3   Slice 7:  A=GP14, B=GP15
        Slice 2: A=GP4,  B=GP5   Slice 8:  A=GP16, B=GP17
        Slice 3: A=GP6,  B=GP7   Slice 9:  A=GP18, B=GP19
        Slice 4: A=GP8,  B=GP9   Slice 10: A=GP20, B=GP21
        Slice 5: A=GP10, B=GP11  Slice 11: A=GP22, B=GP23

    Typical usage:
        PWMSEL 0           — configure slice 0
        PWMWRP 255         — 8-bit resolution (wrap at 255)
        PWMLVL 0, 127      — channel A at 50% duty cycle
        PWMON 0            — enable slice 0

*/

/*

    PWMSEL slice
    Select the active PWM slice for configuration (0-11).

    Example: PWMSEL 2  — subsequent PWMWRP/PWMLVL apply to slice 2

*/
PwmSelCmd:
    jsr Get8Bit                 // slice → Y
    tya
    sta PWM_SELECT
    rts

/*

    PWMLVL chan, level
    Set the duty-cycle level for channel A (0) or B (1) of the selected slice.
    Level ranges from 0 to WRAP (see PWMWRP).

    Example: PWMLVL 0, 127  — 50% duty cycle on channel A (WRAP=255)
             PWMLVL 1, 200  — duty cycle on channel B

*/
PwmLvlCmd:
    jsr Get8Bit                 // channel: 0 = A, 1 = B → Y
    tya
    pha
    jsr basic.CHKCOM
    jsr Get16Bit                // level (0-65535) → $14 (lo), $15 (hi)
    pla
    bne !chanB+
    lda $14                     // Channel A
    sta PWM_LEVEL_A_LO
    lda $15
    sta PWM_LEVEL_A_HI
    rts
!chanB:
    lda $14                     // Channel B
    sta PWM_LEVEL_B_LO
    lda $15
    sta PWM_LEVEL_B_HI
    rts

/*

    PWMWRP wrap
    Set the counter top (wrap) value for the selected slice (0-65535).
    Determines PWM period: higher wrap = finer resolution.

    Example: PWMWRP 255    — 8-bit resolution
             PWMWRP 46874  — ~50 Hz period at 150 MHz / div 64

*/
PwmWrpCmd:
    jsr Get16Bit                // wrap → $14 (lo), $15 (hi)
    lda $14
    sta PWM_WRAP_LO
    lda $15
    sta PWM_WRAP_HI
    rts

/*

    PWMON slice
    Enable a PWM slice (set its bit in PWM_ENABLE).

    Example: PWMON 0  — start PWM output on slice 0

*/
PwmOnCmd:
    jsr Get8Bit                 // slice → Y
    tya
    tax
    lda GpioBitMask, x          // Reuse bit-mask table from gpio.asm
    ora PWM_ENABLE
    sta PWM_ENABLE
    rts

/*

    PWMOFF slice
    Disable a PWM slice (clear its bit in PWM_ENABLE).

    Example: PWMOFF 0  — stop PWM output on slice 0

*/
PwmOffCmd:
    jsr Get8Bit                 // slice → Y
    tya
    tax
    lda GpioBitMask, x
    eor #$ff
    and PWM_ENABLE
    sta PWM_ENABLE
    rts
