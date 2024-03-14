init:
    ; initialises thread.
    ; ----------------
    rep #$20                ; setup pointer
    lda !messagePointerLo   ;
    sta $00                 ;
    sep #$20                ;
    lda !messagePointerBk   ;
    sta $02                 ;
    jsr thread_header_read  ; read header
    lda #$00                ; move pointer
    xba                     ;
    tya                     ;
    rep #$20                ;
    clc                     ;
    adc !messagePointerLo   ;
    sta !messagePointerLo   ;
    sep #$20                ;
    lda #$c0                ; (test) set thread options
    sta !threadOptions      ;
    jsr layer_reserve       ; (test) reserve layer 3
    lda #$02                ;
    sta !threadState        ;
    rts