namespace canvas

upload:
    ; uploads canvas gfx to vram.
    ; ----------------
    ; !textie_arg_pos_gfx (2)      -> vram/canvas position.
    ; !textie_arg_tile_counter (2) -> how many 8px tiles to upload.
    ; ----------------
    ldy !qutie_index                ; get index
    lda.b #!qutie_queue_page        ; adjust sas
    sta $2225                       ;
    lda #$04                        ; type
    sta.w !qutie_type,y             ;
    lda #$02                        ; ccdma settings
    sta.w !qutie_cc_params,y        ;
    rep #$20                        ; transfer size
    lda !textie_arg_tile_counter_lo ;
    asl #4                          ;
    sep #$20                        ;
    sta.w !qutie_size_lo,y          ;
    xba                             ;
    sta.w !qutie_size_hi,y          ;
    rep #$20                        ; vram location
    lda !textie_arg_pos_gfx_lo      ;
    asl #3                          ;
    pha                             ;
    clc                             ;
    adc #$4000                      ;
    sep #$20                        ;
    sta.w !qutie_gp_lo,y            ;
    xba                             ;
    sta.w !qutie_gp_hi,y            ;
    rep #$20                        ; source
    pla                             ;
    asl                             ;
    clc                             ;
    adc.w #!textie_canvas           ;
    sep #$20                        ;
    sta.w !qutie_ram_lo,y           ;
    xba                             ;
    sta.w !qutie_ram_hi,y           ;
    lda.b #(!textie_canvas>>16)     ;
    adc #$00                        ;
    sta.w !qutie_ram_bk,y           ;
    stz $2225                       ; restore sas
    inc !qutie_index                ; next queue index
    rts

namespace off