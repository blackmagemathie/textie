main:

    ; set state
    lda.b #!textie_state_id_wait_input
    sta.w !textie_thread_state

    rts
    