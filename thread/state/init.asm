init:
    ; inits thread.
    ; ----------------

    ; run header
    jsr header_run

    ; set thread option (test)
    lda #$c0
    sta !textie_thread_option

    ; preserve then adjust layer 3 lm settings (test)
    jsr layer_lm_preserve
    jsr layer_lm_set

    ; set thread state to "normal"
    lda #$02
    sta !textie_thread_state
    rts