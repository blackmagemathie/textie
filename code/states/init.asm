init:

    ; clear "word"
    lda.b #!textie_line_flag_in_word
    trb.w !textie_line_option
    
    ; set "in lead"
    lda.b #!textie_line_flag_in_lead
    tsb.w !textie_line_option

    ; run header
    jsr header_run

    ; set thread flags (test)
    lda.b #(!textie_thread_flag_chain_commands+!textie_thread_flag_chain_spaces)
    sta.w !textie_thread_flags

    ; enter "box draw init"
    lda.b #!textie_state_id_box_draw_init
    sta.w !textie_thread_state

    rts
