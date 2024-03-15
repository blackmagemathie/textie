exit:
    ; terminates thread.
    ; ----------------
    stz !textie_thread_state
    rts