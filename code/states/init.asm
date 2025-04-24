init:

    ; clear "word"
    lda.b #!textie_line_flag_in_word
    trb.w !textie_line_option
    
    ; set "in lead"
    lda.b #!textie_line_flag_in_lead
    tsb.w !textie_line_option

    ; run header
    jsr header_run

    ; run box init
    lda.w !textie_box_id
    asl
    tax
    rep #$20
    lda.l box_index_init,x
    sta.w !textie_command_abs
    sep #$20
    pea.w +
    jmp.w (!textie_command_abs)
    +
    nop

    ; jsr layer_lm_preserve
    ; jsr layer_lm_set

    ; set thread option (test)
    lda #$c0
    sta.w !textie_thread_option

    ; enter "box draw"
    lda.b #!textie_state_id_box_draw
    sta.w !textie_thread_state

    rts
