/*

    Cartridge Autostart Stub
    ────────────────────────
    This stub lives at $8000. The C64 KERNAL cold-start routine checks bytes
    $8004–$8008 for the "CBM80" signature ($C3 $C2 $CD $38 $30). When found,
    it treats this as a cartridge and JSRs through the cold vector at $8000.

    Our cold/warm handlers call Init at $C000 (which installs all the
    custom BASIC extension vectors) and then RTS back to the KERNAL so it
    can finish its normal cold-start sequence. BASIC then shows READY with
    the custom tokens already active.

    The KERNAL JSRs to our cold vector — it expects an RTS, not a JMP.
    Jumping to $E394 directly skips the rest of KERNAL init and hangs.

    Result: the BASIC extension is active automatically on every cold start
    and warm reset — no SYS 49152 required.

    Build:
        kickass cart_header.asm -vicesymbols
        python3 ../tools/cartstubgen.py cart_header.prg ../../src/cartstub.h

    Memory map:
        $8000/$8001  Cold start vector lo/hi  → ColdStart ($8009)
        $8002/$8003  Warm start vector lo/hi  → WarmStart ($800C)
        $8004–$8008  CBM80 signature
        $8009        ColdStart routine (JSR $C000, RTS)
        $800C        WarmStart routine (JSR $C000, RTS)

*/

*=$8000

// Cold start vector  (bytes $8000-$8001)
.byte <ColdStart, >ColdStart

// Warm start / NMI vector  (bytes $8002-$8003)
.byte <WarmStart, >WarmStart

// CBM80 signature  (bytes $8004-$8008)
// KERNAL checks these five bytes to detect a cartridge on cold start.
.byte $C3, $C2, $CD, $38, $30  // 'C' 'B' 'M' '8' '0' with bit 7 set

/*

    ColdStart — $8009
    The KERNAL JSRs here after detecting CBM80. Install the extension vectors
    then RTS so the KERNAL continues its normal initialisation sequence.

*/
ColdStart:
    jsr $c000               // Init: installs ConvertToTokens / ConvertFromTokens
                            //       ExecuteCommand / ExecuteFunction vectors
    rts                     // Return to KERNAL — it finishes init, then starts BASIC

/*

    WarmStart — $800C
    Called by the KERNAL on NMI / warm reset.
    Re-install vectors in case RAM was disturbed, then return.

*/
WarmStart:
    jsr $c000               // Re-install BASIC extension vectors
    rts                     // Return to KERNAL NMI handler
