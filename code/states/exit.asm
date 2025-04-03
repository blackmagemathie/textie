exit:

    ; run box exit
    lda.w !textie_box_id
    asl
    tax
    rep #$20
    lda.l box_index_exit,x
    sta.w !textie_command_abs
    sep #$20
    pea.w +
    jmp.w (!textie_command_abs)
    +
    nop
    

    ; kill thread
    stz.w !textie_thread_state
    rts
    