#importonce

// ─────────────────────────────────────────────────────────────────────────────
// RP2350 Memory-Mapped Peripheral Registers (C64+ / Pico 2)
// All addresses within the $D000–$DFFF I/O area.
// See MEMMAP.md for full descriptions and BASIC examples.
// ─────────────────────────────────────────────────────────────────────────────

// ── GPIO ──────────────────────────────────────────────────────────────────────
// 4-byte little-endian 32-bit bitmasks. Bit N = GP(N).
.label GPIO_STATE      = $D02F   // Output state  (1 = HIGH)
.label GPIO_DIRECTION  = $D033   // Direction      (1 = output)
.label GPIO_PULLUP     = $D037   // Pull-up enable (1 = pull-up active)

// ── PWM ───────────────────────────────────────────────────────────────────────
// Select the active slice with PWM_SELECT, then configure wrap/level.
.label PWM_ENABLE      = $D040   // Slice enable bitmask  (bit N = slice N, 0-7)
.label PWM_SELECT      = $D041   // Active slice index    (0-11)
.label PWM_WRAP_LO     = $D042   // Counter top, low byte
.label PWM_WRAP_HI     = $D043   // Counter top, high byte
.label PWM_LEVEL_A_LO  = $D044   // Channel A duty cycle, low byte
.label PWM_LEVEL_A_HI  = $D045   // Channel A duty cycle, high byte
.label PWM_LEVEL_B_LO  = $D046   // Channel B duty cycle, low byte
.label PWM_LEVEL_B_HI  = $D047   // Channel B duty cycle, high byte

// ── I2C ───────────────────────────────────────────────────────────────────────
// I2C0: SDA = GP4, SCL = GP5. Up to 8 bytes per transaction.
.label I2C_ADDR        = $D050   // Target device 7-bit address
.label I2C_DATA        = $D051   // Data buffer base ($D051-$D058)
.label I2C_LEN         = $D059   // Number of bytes to transfer (1-8)
.label I2C_CTRL        = $D05A   // Control: 1 = write, 2 = read
.label I2C_SPEED       = $D05B   // Speed: 0 = 100 kHz, 1 = 400 kHz

// ── DMA ───────────────────────────────────────────────────────────────────────
// DMA channel 11 (reserved). Non-blocking — CPU keeps running during transfer.
.label DMA_CTRL        = $D060   // Control: 1 = start, 2 = abort
.label DMA_SIZE        = $D061   // Transfer width: 0 = byte, 1 = halfword, 2 = word
.label DMA_READ_ADDR   = $D062   // Source address, 32-bit little-endian ($D062-$D065)
.label DMA_WRITE_ADDR  = $D066   // Dest address,   32-bit little-endian ($D066-$D069)
.label DMA_COUNT_LO    = $D06A   // Transfer count, low byte  (1-65535)
.label DMA_COUNT_HI    = $D06B   // Transfer count, high byte
.label DMA_READ_INC    = $D06C   // 1 = increment source address after each transfer
.label DMA_WRITE_INC   = $D06D   // 1 = increment dest   address after each transfer


// ─── SPRITE ─────────────────────────────────────────────────────────────────────────
// Sprite registers are 8 bytes each, for 64 sprites (0-63). Each sprite has a 255x255 pixel bitmap.
.label SPRITE_WIDTH     = $A000   // Width
.label SPRITE_HEIGHT    = $A001   // Height
.label SPRITE_ENABLED   = $A002   // Enable (1 = visible)
.label SPRITE_X_LO      = $A003   // X position, low byte
.label SPRITE_X_HI      = $A004   // X position, high byte
.label SPRITE_Y_LO      = $A005   // Y position, low byte
.label SPRITE_Y_HI      = $A006   // Y position, high byte
.label SPRITE_TRANSPARENCY = $A007   // Transparency the transparency color index (0-255)
.label SPRITE_BITMAP_LO  = $A008   // Bitmap address, low byte
.label SPRITE_BITMAP_HI  = $A009   // Bitmap address, high byte

