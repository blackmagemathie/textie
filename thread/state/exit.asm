exit:
    ; terminates thread.
    ; ----------------
    stz !threadState    ; update thread state.
    rts