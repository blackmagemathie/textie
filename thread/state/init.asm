init:
    ; initialises thread.
    ; ----------------
    rep #$20                ; setup pointer
    lda !textie_message_pointer_lo
    sta $00                 ;
    sep #$20                ;
    lda !textie_message_pointer_bk
    sta $02                 ;
    jsr thread_header_read  ; read header
    lda #$00                ; move pointer
    xba                     ;
    tya                     ;
    rep #$20                ;
    clc                     ;
    adc !textie_message_pointer_lo
    sta !textie_message_pointer_lo
    sep #$20                ;
    lda #$c0                ; (test) set thread options
    sta !textie_thread_option
    jsr layer_lm_preserve   ; (test) preserve then adjust layer 3 lm settings.
    jsr layer_lm_set        ;
    lda #$02                ;
    sta !textie_thread_state
    rts