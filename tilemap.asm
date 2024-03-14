namespace tilemap

upload:
    ; uploads tilemap data to vram. (wip)
    ; > precalculate more values
    ; ----------------
    ; !mapPos (2)      -> tilemap position.
    ; !tileCounter (2) -> how many 8x8 tiles to upload, horizontally.
    ; !argRows         -> how many rows of tiles to upload.
    ; !layerQuarter    -> which part of layer 3 to use.
    ; ----------------
    ; $00-$01 <- (garbage)
    ; ----------------
    ldy !qutie_index        ; get index
    lda.b #!qutie_queue_page; adjust sas
    sta $2225               ;
    rep #$20                ; set initial tilemap pos
    lda !mapPosLo           ;
    sta $00                 ;
    sep #$20                ;
    ldx !argRows            ; get rows
    -
    lda #$00                ; transfer type
    sta.w !qutie_type,y     ;
    rep #$20                ; source
    lda $00                 ;
    asl                     ;
    clc                     ;
    adc.w #!tilemap         ;
    sep #$20                ;
    sta.w !qutie_ram_lo,y   ;
    xba                     ;
    sta.w !qutie_ram_hi,y   ;
    lda.b #(!tilemap>>16)   ;
    sta.w !qutie_ram_bk,y   ;
    rep #$20                ; transfer size
    lda !tileCounterLo      ;
    asl                     ;
    sep #$20                ;
    sta.w !qutie_size_lo,y  ;
    xba                     ;
    sta.w !qutie_size_hi,y  ;
    rep #$20                ; vram location
    lda !layerQuarter-1     ;
    and #$0300              ;
    asl #2                  ;
    ora #$5000              ;
    clc                     ;
    adc $00                 ;
    sep #$20                ;
    sta.w !qutie_gp_lo,y    ;
    xba                     ;
    sta.w !qutie_gp_hi,y    ;
    iny                     ; next queue slot
    dex                     ; one row done!
    beq +                   ; all done?
    rep #$20                ; if no, update tilemap pos
    lda $00                 ;
    clc                     ;
    adc #$0020              ;
    sta $00                 ;
    sep #$20                ;
    bra -                   ; and repeat
    +
    stz $2225               ; restore sas
    sty !qutie_index        ; update queue index
    rts

layText:
    ; lays gfx into textie's tilemap.
    ; ----------------
    ; !argPosGfx (2)   -> gfx position.
    ; !mapPos (2)      -> tilemap position.
    ; !fontHeight      -> how tall are chars, in 8x8 tiles.
    ; !tileCounter (1) -> how many tiles to process horizontally.
    ; !charPalette     -> palette of tiles.
    ; !tilePriority    -> priority of tiles.
    ; ----------------
    lda !fontHeight     ; font height
    sta $00             ;
    lda !tileCounterLo  ; tilemap step (after writing a row)
    asl                 ;
    eor #$ff            ;
    sec                 ;
    adc #$42            ;
    sta $01             ;
    stz $02             ;
    rep #$30            ; tile number and props
    lda !mapPosLo       ;
    asl                 ;
    tay                 ;
    lda !argPosGfxLo    ;
    sta $03             ;
    sep #$20            ;
    lda !charPalette    ;
    asl #2              ;
    tsb $04             ;
    lda !tilePriority   ;
    beq +               ;
    lda #$20            ;
    tsb $04             ;
    +                   ;
    lda.b #!tilemapPage ; adjust sas
    sta $2225           ;
    .loopRows:
        lda !tileCounterLo  ; get tile counter
        sta $05             ;
        rep #$20            ; copy tile numbers and props
        lda $03             ;
        sta $06             ;
        sep #$20            ;
        ..loopTiles:
            rep #$20                    ; write tile
            lda $06                     ;
            sta.w !tilemapAbsolute,y    ;
            sep #$20                    ;
            dec $05                     ; tiles finished?
            beq ..endTiles              ;
            iny #2                      ; if no, increment values
            lda $06                     ;
            sec                         ;
            adc !fontHeight             ;
            sta $06                     ;
            bcc ..loopTiles             ;
            inc $07                     ;
            bra ..loopTiles             ; and continue
        ..endTiles:
        dec $00             ; rows finished?
        bmi .endRows        ;
        rep #$20            ; if no, increment values
        inc $03             ;
        tya                 ;
        clc                 ;
        adc $01             ;
        tay                 ;
        sep #$20            ;
        bra .loopRows       ; and continue
    .endRows:
    sep #$10            ;
    stz $2225           ; restore sas
    rts                 ;

namespace off