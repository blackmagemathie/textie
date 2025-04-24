box_draw:

    ; enter "normal" (test)
    lda.b #!textie_state_id_normal
    sta.w !textie_thread_state

    rts