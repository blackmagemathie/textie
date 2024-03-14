namespace header

read:
    ; reads a message header.
    ; ----------------
    ; $00-$02 <- pointer to header
    ; ----------------
    ldy #$00                            ; set y.
    lda [$00],y                         ; get font.
    sta !textie_font_id                 ;
    jsr font_load                       ;
    iny                                 ;
    lda [$00],y                         ; get background.
    sta !textie_background_id           ;
    iny                                 ;
    rep #$20                            ; get screen and col pos.
    lda [$00],y                         ;
    sta !textie_message_pos_screen_x    ;
    sta !textie_line_pos_screen_x       ;
    sep #$20                            ;
    sta !textie_caret_pos_screen_x      ;
    sta !textie_caret_pos_fill          ;
    iny #2                              ;
    lda [$00],y                         ;
    sta !textie_message_pos_col         ;
    sta !textie_line_pos_col            ;
    sta !textie_caret_pos_col           ;
    iny                                 ;
    lda [$00],y                         ; get line width.
    sta !textie_line_width              ;
    iny                                 ;
    lda [$00],y                         ; get line option.
    sta !textie_line_option             ;
    and #$a8                            ;
    iny                                 ;
    rep #$20                            ; get starting gfx pos.
    lda [$00],y                         ;
    sta !textie_message_pos_gfx_lo      ;
    sta !textie_line_pos_gfx_lo         ;
    sep #$20                            ;
    iny #2                              ;
    lda [$00],y                         ; get spaces.
    sta !textie_space_postchar          ;
    iny                                 ;
    lda [$00],y                         ;
    sta !textie_space_regular           ;
    iny                                 ;
    lda [$00],y                         ; get char palette.
    sta !textie_char_palette            ;
    iny                                 ;
    lda [$00],y                         ; get char option.
    sta !textie_char_option             ;
    iny                                 ;
    lda [$00],y : sta !textie_char_transpose+0 : iny ; get color transposition.
    lda [$00],y : sta !textie_char_transpose+1 : iny ;
    lda [$00],y : sta !textie_char_transpose+2 : iny ;
    lda [$00],y : sta !textie_char_transpose+3 : iny ;
    rts

namespace off