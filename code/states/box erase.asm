box_erase:

    ; enter "exit" (test)
    lda.b #!textie_state_id_exit
    sta.w !textie_thread_state

    rts