run_message:

    ; get pointers
    rep #$30
    lda.w !textie_message_id
    asl
    clc
    adc.w !textie_message_id
    tax
    lda.l message_data_index+0,x  : sta.w !textie_message_pointer
    lda.l message_data_header+0,x : sta.w !textie_header_pointer
    sep #$20
    lda.l message_data_index+2,x  : sta.w !textie_message_pointer+2
    lda.l message_data_header+2,x : sta.w !textie_header_pointer+2
    
    ; use header 01, box 01
    lda #$01 : sta.w !textie_header_id
    lda #$01 : sta.w !textie_box_id

    ; enter "init"
    lda.b #!textie_state_id_init
    sta.w !textie_thread_state

    rts