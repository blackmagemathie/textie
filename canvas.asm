namespace canvas

upload:
    ; uploads canvas gfx to vram.
    ; ----------------
    ; !argPosGfx (2)   -> gfx/canvas position.
    ; !tileCounter (2) -> how many 8x8 tiles to upload.
    ; ----------------
    ldy !qutie_index        ; get index
    lda.b #!qutie_queue_page; adjust sas
    sta $2225               ;
    lda #$04                ; type
    sta.w !qutie_type,y     ;
    lda #$02                ; ccdma settings
    sta.w !qutie_cc_params,y;
    rep #$20                ; transfer size
    lda !tileCounterLo      ;
    asl #4                  ;
    sep #$20                ;
    sta.w !qutie_size_lo,y  ;
    xba                     ;
    sta.w !qutie_size_hi,y  ;
    rep #$20                ; vram location
    lda !argPosGfxLo        ;
    asl #3                  ;
    pha                     ;
    clc                     ;
    adc #$4000              ;
    sep #$20                ;
    sta.w !qutie_gp_lo,y    ;
    xba                     ;
    sta.w !qutie_gp_hi,y    ;
    rep #$20                ; source
    pla                     ;
    asl                     ;
    clc                     ;
    adc.w #!canvas          ;
    sep #$20                ;
    sta.w !qutie_ram_lo,y   ;
    xba                     ;
    sta.w !qutie_ram_hi,y   ;
    lda.b #(!canvas>>16)    ;
    adc #$00                ;
    sta.w !qutie_ram_bk,y   ;
    stz $2225               ; restore sas
    inc !qutie_index        ; next queue index
    rts

namespace off