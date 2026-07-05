//--------------------------------
// cartridge start
//--------------------------------

.label BASIC_IDLE = $fffc

* = $8000
//* = $0820
.word cold_start
.word warm_start
.byte $c3,$c2,$cd,$38,$30 // cartridge magic bytes, CBM80

cold_start:
        stx $d016
        jsr $FDA3       // IOINIT, init CIA,IRQ
        jsr $FD50       // RAMTAS, init memory
        jsr $FD15       // RESTOR, init I/O
        jsr $FF5B       // SCINIT, init video
        cli
        jsr $E453       // load BASIC vectors
        jsr $E3BF       // init BASIC RAM
        jsr $E422       // print BASIC start up messages
        ldx #$FB        // init BASIC stack
        txs
        jmp $c000
        
warm_start:
        stx $d016
        jsr $FDA3       // IOINIT, init CIA,IRQ
        jsr $FD50       // RAMTAS, init memory
        jsr $FD15       // RESTOR, init I/O
        jsr $FF5B       // SCINIT, init video
        cli
        jmp $c000

