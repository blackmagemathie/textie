namespace wrap

testWord:
    ; checks if a word fits a given width.
    ; ----------------
    ; $00-$02           -> message pointer.
    ; !textie_arg_width -> tested width (inclusive).
    ; ----------------
    ; carry   <- clear = fits; set = doesn't fit.
    ; $00-$07 <- (garbage)
    ; ----------------
    lda !textie_space_postchar  ; get postchar space.
    sta $07                     ;
    rep #$20                    ; get pointer to font widths.
    lda !textie_font_widths_lo  ;
    sta $04                     ;
    sep #$20                    ;
    lda !textie_font_data_bk    ;
    sta $06                     ;
    stz $03                     ; clear width.
    .loop:
        jsr .compare    ; fits?
        bcs .end        ; if no, end
        lda [$00]       ; else, continue
        beq .cmd        ;
        cmp #$ff        ;
        beq .compare    ;
        bra .char       ;
    .compare:
        lda $03
        cmp !textie_arg_width
        bne +
        clc
        +
     .end:
        rts
    ; ----
    .cmd:
        ldy #$01                        ; get command index
        lda [$00],y                     ;
        asl #3                          ;
        tax                             ;
        lda.w thread_command_list+3,x   ; ignore?
        bit #$04                        ;
        bne +                           ;
        bit #$02                        ; jump to final comparison?
        bne .compare                    ;
        iny                             ; execute command (wrap routine)
        phx                             ;
        jsr.w (thread_command_list+4,x) ;
        plx                             ;
        +
        lda #$00                        ; move pointer
        xba                             ;
        lda.w thread_command_list+2,x   ;
        inc #2                          ;
        rep #$20                        ;
        clc                             ;
        adc $00                         ;
        sta $00                         ;
        sep #$20                        ;
        bra .loop
    ; ----
    .char:
        tay         ; add char width and postchar space
        lda [$04],y ;
        clc         ;
        adc $03     ;
        clc         ;
        adc $07     ;
        sta $03     ;
        rep #$20    ; move pointer
        inc $00     ;
        sep #$20    ;
        bra .loop

namespace off