main:

    ; set time
    lda [$00],y
    dec
    sta !textie_thread_wait

    ; set state
    lda.b #!textie_state_id_wait_frames
    sta.w !textie_thread_state

    rts
    