namespace background

draw:
    ; fills canvas with background gfx.
    ; > optimise for plain colors (0 to 3)
    ; ----------------
    ; !textie_arg_pos_gfx (2)      -> canvas position.
    ; !textie_arg_tile_counter (1) -> how many 8px tiles to fill.
    ; !textie_background_id        -> background id.
    ; ----------------
    lda !textie_arg_tile_counter_lo ; set tile counter
    bne +                           ;
    rts                             ;
    +                               ;
    sta $3100                       ;
    rep #$30                        ; get index
    lda !textie_arg_pos_gfx_lo      ;
    asl #4                          ;
    tay                             ;
    lda !textie_background_id           ; buffer background gfx.
    and #$00ff                          ;
    asl #4                              ;
    tax                                 ;
    lda.l backgrounds+$0,x : sta $00    ;
    lda.l backgrounds+$2,x : sta $02    ;
    lda.l backgrounds+$4,x : sta $04    ;
    lda.l backgrounds+$6,x : sta $06    ;
    lda.l backgrounds+$8,x : sta $08    ;
    lda.l backgrounds+$a,x : sta $0a    ;
    lda.l backgrounds+$c,x : sta $0c    ;
    lda.l backgrounds+$e,x : sta $0e    ;
    tyx                                 ;
    -
    lda $00 : sta.l !textie_canvas+$0,x ; fill a tile.
    lda $02 : sta.l !textie_canvas+$2,x ;
    lda $04 : sta.l !textie_canvas+$4,x ;
    lda $06 : sta.l !textie_canvas+$6,x ;
    lda $08 : sta.l !textie_canvas+$8,x ;
    lda $0a : sta.l !textie_canvas+$a,x ;
    lda $0c : sta.l !textie_canvas+$c,x ;
    lda $0e : sta.l !textie_canvas+$e,x ;
    sep #$20    ; done?
    dec $3100   ;
    beq +       ;
    rep #$20    ; if not, increase index,
    txa         ;
    clc         ;
    adc #$0010  ;
    tax         ;
    bra -       ; and keep going.
    +           ;
    sep #$10    ;
    rts
    
namespace off
