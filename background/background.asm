namespace background

draw:
    ; fills canvas with background gfx.
    ; > optimise for plain colors (0 to 3)
    ; ----------------
    ; !textie_arg_pos_gfx (2)      -> canvas position.
    ; !textie_arg_tile_counter (1) -> how many 8px tiles to fill.
    ; !textie_background_id        -> background id.
    ; ----------------
    lda !textie_arg_tile_counter ; tile count zero?
    bne +                           ; if yes,
    rts                             ; return.
    +                               ;
    sta $3100                       ; else, set counter.
    rep #$30                        ; get index to bg gfx.
    lda !textie_arg_pos_gfx      ;
    asl #4                          ;
    tay                             ;
    lda !textie_background_id               ; buffer background gfx.
    and #$00ff                              ;
    asl #4                                  ;
    tax                                     ;
    lda.l background_data+$0,x : sta $00    ;
    lda.l background_data+$2,x : sta $02    ;
    lda.l background_data+$4,x : sta $04    ;
    lda.l background_data+$6,x : sta $06    ;
    lda.l background_data+$8,x : sta $08    ;
    lda.l background_data+$a,x : sta $0a    ;
    lda.l background_data+$c,x : sta $0c    ;
    lda.l background_data+$e,x : sta $0e    ;
    tyx                                     ;
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
    beq +       ; if not,
    rep #$20    ; increase index,
    txa         ;
    clc         ;
    adc #$0010  ;
    tax         ;
    bra -       ; and keep going.
    +
    sep #$10
    rts

namespace off
