main:
    lda [$00],y
    lsr
    lda #$80
    bcc +
    tsb !textie_char_option
    rts
    +
    trb !textie_char_option
    rts