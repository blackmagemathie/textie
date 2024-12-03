namespace background

draw:
    ; fills canvas with background gfx.
    ; ----------------
    ; !textie_arg_pos_gfx (2)      -> canvas pos
    ; !textie_arg_tile_counter (1) -> how many 8px tiles to fill
    ; !textie_background_id (1)    -> background id
    ; ----------------

    ; if counter zero, end
    lda !textie_arg_tile_counter
    bne +
    rts
    +

    ; set counter, get index to gfx
    tay
    rep #$30
    lda !textie_arg_pos_gfx
    asl #4
    pha
    sep #$20

    ; plain color?
    lda !textie_background_id
    cmp #$04
    bcs .donut

    .plain:
        ; buffer 2 bytes
        asl #2 : ora !textie_background_id
        asl #2 : ora !textie_background_id
        asl #2 : ora !textie_background_id
        sta $00
        sta $01
        rep #$20
        plx
        ; fill tile
        -
        lda $00
        sta.l !textie_canvas+$0,x
        sta.l !textie_canvas+$2,x
        sta.l !textie_canvas+$4,x
        sta.l !textie_canvas+$6,x
        sta.l !textie_canvas+$8,x
        sta.l !textie_canvas+$a,x
        sta.l !textie_canvas+$c,x
        sta.l !textie_canvas+$e,x
        ; done?
        sep #$20
        dey
        beq +
        ; if no, inc index
        rep #$20
        txa
        clc
        adc #$0010
        tax
        bra -
        ; end
        +
        sep #$10
        rts

    .donut:
        ; buffer gfx
        rep #$20
        and #$00ff
        asl #4
        tax
        lda.l background_data+$0,x : sta $00
        lda.l background_data+$2,x : sta $02
        lda.l background_data+$4,x : sta $04
        lda.l background_data+$6,x : sta $06
        lda.l background_data+$8,x : sta $08
        lda.l background_data+$a,x : sta $0a
        lda.l background_data+$c,x : sta $0c
        lda.l background_data+$e,x : sta $0e
        plx
        ; fill tile
        -
        lda $00 : sta.l !textie_canvas+$0,x
        lda $02 : sta.l !textie_canvas+$2,x
        lda $04 : sta.l !textie_canvas+$4,x
        lda $06 : sta.l !textie_canvas+$6,x
        lda $08 : sta.l !textie_canvas+$8,x
        lda $0a : sta.l !textie_canvas+$a,x
        lda $0c : sta.l !textie_canvas+$c,x
        lda $0e : sta.l !textie_canvas+$e,x
        ; done?
        sep #$20
        dey
        beq +
        ; if no, inc index
        rep #$20
        txa
        clc
        adc #$0010
        tax
        bra -
        ; end
        +
        sep #$10
        rts

namespace off
