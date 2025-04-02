wait_frames:

    ; dec counter
    dec.w !textie_thread_wait
    beq +
    rts
    +
    ; back to "normal"
    lda.b #!textie_state_id_normal
    sta.w !textie_thread_state
    rts