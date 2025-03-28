namespace util

moveCaret:
    ; moves caret within line.
    ; ----------------
    ; !textie_arg_move <- horizontal movement (in px, signed).
    ; ----------------
    lda !textie_caret_pos_screen_x
    asl #3
    ora !textie_caret_pos_col
    clc
    adc !textie_arg_move
    sta !textie_caret_pos_col
    lsr #3
    sta !textie_caret_pos_screen_x
    lda #$f8
    trb !textie_caret_pos_col
    rts

breakLine:
    ; start a new line.
    ; ----------------

    ; set gfx pos
    stz $2250
    lda !textie_caret_pos_fill
    sec
    sbc !textie_line_pos_screen_x
    sta $2251
    stz $2252
    lda !textie_font_height
    inc
    sta $2253
    stz $2254
    rep #$20
    nop
    lda $2306
    clc
    adc !textie_line_pos_gfx
    sta !textie_line_pos_gfx
    sep #$20

    ; set screen and col pos
    lda !textie_message_pos_screen_x
    sta !textie_line_pos_screen_x
    sta !textie_caret_pos_screen_x
    sta !textie_caret_pos_fill
    lda !textie_line_pos_screen_y
    sec
    adc !textie_font_height
    sta !textie_line_pos_screen_y
    lda !textie_message_pos_col
    sta !textie_line_pos_col
    sta !textie_caret_pos_col

    ; clear word flag
    lda #$40
    trb !textie_line_option

    rts

namespace off