/*

    Typical usage:
        PWMINIT 0          — configure PIN0 for PWM output
        PWMFRQ 2000        — 2000 Hz frequency (wrap = 62500)
        PWMLVL 0, 127      — PIN 0 channel A duty cycle 50% (127/255)
        PWMON 0            — enable slice 0

*/

/*
    PWMINIT Pin
    Initialize a GPIO pin for PWM output. This sets the pin function to PWM and initializes the corresponding PWM slice with default settings.
    Example: PWMINIT 2  — initialize PIN 2 for PWM output
*/
PwmInitCmd:
    jsr Get8Bit                 // pin → Y
    tya
    SysCall(PWM_SETUP)
    rts

/*
    PWMFRQ pin, freq
    Set the PWM frequency for the selected slice. The frequency is determined by the system clock and the wrap value.
    Example: PWMFRQ 1000  — set PWM frequency to 1000 Hz
*/

PwmFrqCmd:
    jsr Get8Bit                 // pin → Y
    tya
    pha
    jsr basic.CHKCOM
    jsr Get16Bit                // Get the address to WOKE to
    pla
    ldx $14
    ldy $15
    SysCall(PWM_SET_FREQ)
    rts

/*

    PWMLVL chan, level
    Set the duty-cycle level for channel A (0) or B (1) of the selected slice.
    Level ranges from 0 to WRAP (see PWMWRP).

    Example: PWMLVL 0, 127  — 50% duty cycle on channel A (WRAP=255)
             PWMLVL 1, 200  — duty cycle on channel B

*/
PwmLvlCmd:
    jsr Get8Bit                 // pin → Y
    tya
    pha
    jsr basic.CHKCOM
    jsr Get16Bit        // Get the address to WOKE to
    pla
    ldx $14
    ldy $15
    SysCall(PWM_SET_DUTY)
    rts


/*
    PWMON 25
    Enable a PWM pin.

    Example: PWMON 0  — start PWM output on slice 0
*/

PwmOnCmd:
    jsr Get8Bit                 // pin → Y
    tya
    ldx #$01
    SysCall(PWM_CONTROL)
    rts

/*

    PWMOFF pin
    Disable a PWM pin.

    Example: PWMOFF 25,0  — stop PWM output on pin25
*/
PwmOffCmd:
    jsr Get8Bit                 // pin → Y
    tya
    ldx #$00
    SysCall(PWM_CONTROL)
    rts
