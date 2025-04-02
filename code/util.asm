namespace util

moveCaret:
    ; moves caret within line.
    ; ----------------
    ; !textie_arg_move <- horizontal movement (in px, signed).
    ; ----------------

    lda.w !textie_arg_move
    clc
    adc.w !textie_caret_pos_col
    sta.w !textie_caret_pos_col
    lsr #3
    clc
    adc.w !textie_caret_pos_screen_x
    sta.w !textie_caret_pos_screen_x
    lda #$f8
    trb.w !textie_caret_pos_col

    rts

breakLine:
    ; start a new line.
    ; ----------------

    ; set gfx pos
    stz $2250
    lda.w !textie_caret_pos_fill
    sec
    sbc.w !textie_line_pos_screen_x
    sta $2251
    stz $2252
    lda.w !textie_font_height
    inc
    sta $2253
    stz $2254
    rep #$20
    nop
    lda $2306
    clc
    adc.w !textie_line_pos_gfx
    sta.w !textie_line_pos_gfx
    sep #$20

    ; set screen and col pos
    lda.w !textie_message_pos_screen_x
    sta.w !textie_line_pos_screen_x
    sta.w !textie_caret_pos_screen_x
    sta.w !textie_caret_pos_fill
    lda.w !textie_line_pos_screen_y
    sec
    adc.w !textie_font_height
    sta.w !textie_line_pos_screen_y
    lda.w !textie_message_pos_col
    sta.w !textie_line_pos_col
    sta.w !textie_caret_pos_col

    ; clear "word"
    lda.b #!textie_line_flag_in_word
    trb.w !textie_line_option

    ; set "in lead"
    lda.b #!textie_line_flag_in_lead
    tsb.w !textie_line_option

    rts

namespace off