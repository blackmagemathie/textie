main:
    lda [$00],y
    lsr
    lda.b #!textie_line_flag_wrap
    bcc +
    tsb.w !textie_line_option
    rts
    +
    trb.w !textie_line_option
    rts
    