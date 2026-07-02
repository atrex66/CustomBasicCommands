/*

    I2C Commands — I2CADR, I2CWRT, I2CRDT, I2CSPD
    ─────────────────────────────────────────────────
    Hardware: I2C0, SDA = GP4, SCL = GP5.
    Up to 8 bytes per transaction (use POKE to fill I2C_DATA buffer first).

    Typical write flow:
        I2CADR 60          — set device address (0x3C)
        POKE 53329, 0      — I2C_DATA[0] = command byte
        POKE 53330, 255    — I2C_DATA[1] = data byte
        I2CWRT 2           — send 2 bytes

    Typical read flow:
        I2CADR 60
        I2CRDT 1           — request 1 byte
        PRINT PEEK(53329)  — read result from I2C_DATA[0]

*/

/*

    I2CADR addr
    Set the 7-bit I2C target device address (0-127).

    Example: I2CADR 60  — target SSD1306 OLED at address 0x3C

*/
I2cAdrCmd:
    jsr Get8Bit                 // address → Y
    tya
    sta I2C_ADDR
    rts

/*

    I2CWRT len
    Write len bytes from the I2C_DATA buffer to the selected device (1-8).
    Fill I2C_DATA ($D051-$D058) via POKE before calling this.

    Example: I2CWRT 1  — send I2C_DATA[0]

*/
I2cWrtCmd:
    jsr Get8Bit                 // length → Y
    tya
    sta I2C_LEN
    lda #$01                    // CTRL = 1: start write
    sta I2C_CTRL
    rts

/*

    I2CRDT len
    Read len bytes from the selected device into the I2C_DATA buffer (1-8).
    Read results back via PEEK($D051) etc. after the transaction completes.

    Example: I2CRDT 2  — receive 2 bytes into I2C_DATA[0] and [1]

*/
I2cRdtCmd:
    jsr Get8Bit                 // length → Y
    tya
    sta I2C_LEN
    lda #$02                    // CTRL = 2: start read
    sta I2C_CTRL
    rts

/*

    I2CSPD spd
    Set the I2C bus speed: 0 = 100 kHz (standard), 1 = 400 kHz (fast).

    Example: I2CSPD 1  — switch to 400 kHz fast mode

*/
I2cSpdCmd:
    jsr Get8Bit                 // speed → Y
    tya
    sta I2C_SPEED
    rts
