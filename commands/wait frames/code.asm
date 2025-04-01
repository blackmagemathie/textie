main:
    lda [$00],y
    dec
    sta !textie_thread_wait
    rts
    