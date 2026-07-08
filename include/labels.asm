#importonce

// Timers are stored in the tape buffer. Hopefully you're not using tape.
.label c64lib_timers = kernal.TBUFFER

// Enable/Disable flags
.label ENABLE  = $80
.label DISABLE = $00
.label TRUE    = ENABLE
.label FALSE   = DISABLE

// Timer constants
.label TIMER_SINGLE         = $00
.label TIMER_CONTINUOUS     = $01
.label TIMER_HALF_SECOND    = $1e
.label TIMER_ONE_SECOND     = $3c
.label TIMER_TWO_SECONDS    = $78
.label TIMER_THREE_SECONDS  = $b4
.label TIMER_FOUR_SECONDS   = $f0
.label TIMER_STRUCT_BYTES   = $40

// The bank the VIC-II chip will be in
.label BANK = $00

// The start of physical RAM the VIC-II will see
.label VIC_START = (BANK * $4000)

// Offsets for start of VIC memory for each sprite attribute
.label SPR_VISIBLE  = vic.SPENA   - vic.SP0X
.label SPR_X_EXPAND = vic.XXPAND  - vic.SP0X
.label SPR_Y_EXPAND = vic.YXPAND  - vic.SP0X
.label SPR_HMC      = vic.SPMC    - vic.SP0X
.label SPR_PRIORITY = vic.SPBGPR  - vic.SP0X

// Flags for various sprite settings
.label SPR_HIDE       = DISABLE
.label SPR_SHOW       = ENABLE
.label SPR_NORMAL     = DISABLE
.label SPR_EXPAND     = ENABLE
.label SPR_FG         = DISABLE
.label SPR_BG         = ENABLE
.label SPR_HIRES      = DISABLE
.label SPR_MULTICOLOR = ENABLE

// Joystick constants
.label JOY_BUTTON = %00010000
.label JOY_UP     = %00000001
.label JOY_DOWN   = %00000010
.label JOY_LEFT   = %00000100
.label JOY_RIGHT  = %00001000

.label PWM_SETUP = $80
.label PWM_SET_FREQ = $81
.label PWM_SET_DUTY = $82
.label PWM_CONTROL = $83
.label PWM_DEINIT = $84

.label GPIO_SET_PINMODE = $90
.label GPIO_SET_PINOUT = $91
.label GPIO_SET_PINPULL = $92
.label GPIO_GET_PINSTATE = $93

.label ADC_READ = $A0
.label ADC_INIT = $A1

.label DMA_INIT = $B0
.label DMA_SET_SIZE = $B1
.label DMA_SET_INCREMENT = $B2
.label DMA_SET_TRANSFER_COUNT = $B3
.label DMA_SET_SRC = $B4
.label DMA_SET_DST = $B5
.label DMA_START = $B6
.label DMA_WAIT_COMPLETE = $B7
.label DMA_ABORT = $B8
.label DMA_GET_STATUS = $B9

.label WAIT_FRAME = $C0
