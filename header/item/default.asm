default:
    ldy #$00

    ; get font
    lda [$00],y
    sta !textie_font_id
    jsr font_load
    iny

    ; get background
    lda [$00],y
    sta !textie_background_id
    iny

    ; get screen and col pos
    rep #$20
    lda [$00],y
    sta !textie_message_pos_screen_x
    sta !textie_line_pos_screen_x
    sep #$20
    sta !textie_caret_pos_screen_x
    sta !textie_caret_pos_fill
    iny #2
    lda [$00],y
    sta !textie_message_pos_col
    sta !textie_line_pos_col
    sta !textie_caret_pos_col
    iny

    ; get line width
    lda [$00],y
    sta !textie_line_width
    iny

    ; get line option
    lda [$00],y
    sta !textie_line_option
    and #$a8
    iny

    ; get starting gfx pos
    rep #$20
    lda [$00],y
    sta !textie_message_pos_gfx
    sta !textie_line_pos_gfx
    sep #$20
    iny #2

    ; get spaces
    lda [$00],y
    sta !textie_space_postchar
    iny
    lda [$00],y
    sta !textie_space_regular
    iny

    ; get char palette
    lda [$00],y
    sta !textie_char_palette
    iny

    ; get char option
    lda [$00],y
    sta !textie_char_option
    iny

    ; get color transposition
    lda [$00],y : sta !textie_char_transpose+0 : iny
    lda [$00],y : sta !textie_char_transpose+1 : iny
    lda [$00],y : sta !textie_char_transpose+2 : iny
    lda [$00],y : sta !textie_char_transpose+3 : iny
    rts