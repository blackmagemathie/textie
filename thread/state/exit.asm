exit:
    ; terminates thread.
    ; ----------------
    stz !textie_thread_state    ; update thread state.
    rts