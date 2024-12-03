classic:
    ; set font and bg
    stz !textie_font_id
    jsr font_load
    stz !textie_background_id

    ; set screen and col pos
    rep #$20
    lda #$0607
    sta !textie_message_pos_screen_x
    sta !textie_line_pos_screen_x
    sep #$20
    sta !textie_caret_pos_screen_x
    sta !textie_caret_pos_fill
    stz !textie_message_pos_col
    stz !textie_line_pos_col
    stz !textie_caret_pos_col

    ; set line
    lda #$90
    sta !textie_line_width
    lda #$a0
    sta !textie_line_option
    
    ; set gfx pos
    rep #$20
    lda #$0001
    sta !textie_message_pos_gfx
    sta !textie_line_pos_gfx
    sep #$20

    ; set space
    lda #$01
    sta !textie_space_postchar
    lda #$04
    sta !textie_space_regular

    ; set char
    lda #$07
    sta !textie_char_palette
    lda #$40
    sta !textie_char_option

    rts