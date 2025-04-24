box_clear:

    .init:
        lda.w !textie_box_id
        asl
        tax
        rep #$20
        lda.l box_index_clear_init,x
        sta.w !textie_command_abs
        sep #$20
        pea.w +
        jmp.w (!textie_command_abs)
        +
        nop
        
        ; enter "box clear main"
        lda.b #!textie_state_id_box_clear_main
        sta.w !textie_thread_state
        
        rts

    .main:
        lda.w !textie_box_id
        asl
        tax
        rep #$20
        lda.l box_index_clear_main,x
        sta.w !textie_command_abs
        sep #$20
        pea.w +
        jmp.w (!textie_command_abs)
        +
        nop
        
        ; enter "normal" if carry set
        bcc +
        lda.b #!textie_state_id_normal
        sta.w !textie_thread_state
        +

        rts