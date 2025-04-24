main:
    lda [$00],y
    and #$07
    sta !textie_char_palette
    rts
    