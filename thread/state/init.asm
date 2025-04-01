init:
    ; inits thread.
    ; ----------------

    ; clear "word"
    lda.b #!textie_line_flag_in_word
    trb.w !textie_line_option
    
    ; set "in lead"
    lda.b #!textie_line_flag_in_lead
    tsb.w !textie_line_option

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