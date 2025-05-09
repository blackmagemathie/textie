box_erase:

    .init:
        lda.w !textie_box_id
        asl
        tax
        rep #$20
        lda.l box_index_erase_init,x
        sta.w !textie_command_abs
        sep #$20
        pea.w +
        jmp.w (!textie_command_abs)
        +
        nop
        
        ; enter "box erase main"
        lda.b #!textie_state_id_box_erase_main
        sta.w !textie_thread_state
        
        rts

    .main:
        lda.w !textie_box_id
        asl
        tax
        rep #$20
        lda.l box_index_erase_main,x
        sta.w !textie_command_abs
        sep #$20
        pea.w +
        jmp.w (!textie_command_abs)
        +
        nop
        
        ; enter "exit" if carry set
        bcc +
        lda.b #!textie_state_id_exit
        sta.w !textie_thread_state
        +

        rts