wait_input:

    ; a or b?
    lda $16
    ora $18
    bmi +
    rts
    +
    ; back to "normal"
    lda.b #!textie_state_id_normal
    sta.w !textie_thread_state
    rts