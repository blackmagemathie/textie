namespace tilemap

upload:
    ; uploads tilemap data to vram.
    ; > precalculate more values
    ; ----------------
    ; !textie_arg_tilemap_pos (2)  -> tilemap position.
    ; !textie_arg_tile_counter (2) -> how many 8px tiles to upload, horizontally.
    ; !textie_arg_rows             -> how many rows of tiles to upload.
    ; !textie_arg_quarter          -> layer 3 quarter to upload to.
    ; ----------------
    ; $00-$01 <- (garbage)
    ; ----------------
    ldy !qutie_index                ; get qutie index.
    lda.b #!qutie_queue_page        ; adjust sas mapping.
    sta $318f                       ;
    sta $2225                       ;
    rep #$20                        ; set initial tilemap pos.
    lda !textie_arg_tilemap_pos_lo  ;
    sta $00                         ;
    sep #$20                        ;
    ldx !textie_arg_rows            ; get rows in x.
    -       
    lda #$00                        ; set transfer type.
    sta.w !qutie_type,y             ;
    rep #$20                        ; set source.
    lda $00                         ;
    asl                             ;
    clc                             ;
    adc.w #!textie_tilemap          ;
    sep #$20                        ;
    sta.w !qutie_ram_lo,y           ;
    xba                             ;
    sta.w !qutie_ram_hi,y           ;
    lda.b #(!textie_tilemap>>16)    ;
    sta.w !qutie_ram_bk,y           ;
    rep #$20                        ; set transfer size.
    lda !textie_arg_tile_counter_lo ;
    asl                             ;
    sep #$20                        ;
    sta.w !qutie_size_lo,y          ;
    xba                             ;
    sta.w !qutie_size_hi,y          ;
    rep #$20                        ; set vram pos.
    lda !textie_arg_quarter-1       ;
    and #$0300                      ;
    asl #2                          ;
    ora #$5000                      ;
    clc                             ;
    adc $00                         ;
    sep #$20                        ;
    sta.w !qutie_gp_lo,y            ;
    xba                             ;
    sta.w !qutie_gp_hi,y            ;
    iny                 ; next queue slot.
    dex                 ; one row done!
    beq +               ; all done? if no,
    rep #$20            ; update tilemap pos,
    lda $00             ;
    clc                 ;
    adc #$0020          ;
    sta $00             ;
    sep #$20            ;
    bra -               ; and keep going.
    +           
    stz $2225           ; restore sas mapping.
    stz $318f           ;
    sty !qutie_index    ; update qutie index.
    rts

layText:
    ; lays gfx into tilemap.
    ; ----------------
    ; !textie_arg_pos_gfx (2)      -> gfx position.
    ; !textie_arg_tilemap_pos (2)  -> tilemap position.
    ; !textie_font_height          -> char height (in 8px tiles, -1).
    ; !textie_arg_tile_counter (1) -> how many tiles to process horizontally.
    ; !textie_char_palette         -> palette of tiles.
    ; !textie_arg_tile_priority    -> priority of tiles.
    ; ----------------
    lda !textie_font_height         ; get font height.
    sta $00                         ;
    lda !textie_arg_tile_counter_lo ; get tilemap step.
    asl                             ;
    eor #$ff                        ;
    sec                             ;
    adc #$42                        ;
    sta $01                         ;
    stz $02                         ;
    rep #$30                        ; get tile number and props.
    lda !textie_arg_tilemap_pos_lo  ;
    asl                             ;
    tay                             ;
    lda !textie_arg_pos_gfx_lo      ;
    sta $03                         ;
    sep #$20                        ;
    lda !textie_char_palette        ;
    asl #2                          ;
    tsb $04                         ;
    lda !textie_arg_tile_priority   ;
    beq +                           ;
    lda #$20                        ;
    tsb $04                         ;
    +                               ;
    lda.b #!textie_tilemap_page     ; adjust sas mapping.
    sta $318f                       ;
    sta $2225                       ;
    .loopRows:
        lda !textie_arg_tile_counter_lo ; get tile counter.
        sta $05                         ;
        rep #$20                        ; copy tile numbers and props.
        lda $03                         ;
        sta $06                         ;
        sep #$20                        ;
        ..loopTiles:
            rep #$20                    ; write tile.
            lda $06                     ;
            sta.w !textie_tilemap_abs,y ;
            sep #$20                    ;
            dec $05                     ; tiles finished?
            beq ..endTiles              ; if no,
            iny #2                      ; set values for next one,
            lda $06                     ;
            sec                         ;
            adc !textie_font_height     ;
            sta $06                     ;
            bcc ..loopTiles             ;
            inc $07                     ;
            bra ..loopTiles             ; and keep going.
        ..endTiles:
        dec $00             ; rows finished?
        bmi .endRows        ; if no, 
        rep #$20            ; set values for next one,
        inc $03             ;
        tya                 ;
        clc                 ;
        adc $01             ;
        tay                 ;
        sep #$20            ;
        bra .loopRows       ; and keep going.
    .endRows:
    stz $2225   ; restore sas mapping.
    stz $318f   ;
    sep #$10
    rts

namespace off