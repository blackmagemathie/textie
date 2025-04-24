box_draw:

    .init:
        lda.w !textie_box_id
        asl
        tax
        rep #$20
        lda.l box_index_draw_init,x
        sta.w !textie_command_abs
        sep #$20
        pea.w +
        jmp.w (!textie_command_abs)
        +
        nop
        
        ; enter "box draw main"
        lda.b #!textie_state_id_box_draw_main
        sta.w !textie_thread_state
        
        rts

    .main:
        lda.w !textie_box_id
        asl
        tax
        rep #$20
        lda.l box_index_draw_main,x
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