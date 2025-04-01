main:
    lda [$00],y : sta !textie_char_transpose+0 : iny
    lda [$00],y : sta !textie_char_transpose+1 : iny
    lda [$00],y : sta !textie_char_transpose+2 : iny
    lda [$00],y : sta !textie_char_transpose+3
    rts
    