init:
    ; initialises thread.
    ; ----------------
    jsr header_process              ; process header.
    lda #$c0                        ; (test) set thread option.
    sta !textie_thread_option       ;
    jsr layer_lm_preserve           ; (test) preserve then adjust layer 3 lm settings.
    jsr layer_lm_set                ;
    lda #$02                        ;
    sta !textie_thread_state        ; set thread state to "normal".
    rts