exit:

    ; kill thread
    stz.w !textie_thread_state
    rts
    