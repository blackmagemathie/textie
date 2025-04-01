main:
    lda [$00],y
    lsr
    lda #$20
    bcc +
    tsb !textie_line_option
    rts
    +
    trb !textie_line_option
    rts
    