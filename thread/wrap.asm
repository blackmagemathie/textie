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

    ; get postchar space
    lda !textie_space_postchar
    sta $07

    ; get pointer to font widths
    rep #$20
    lda !textie_font_widths
    sta $04
    sep #$20
    lda !textie_font_bk
    sta $06

    ; clear width
    stz $03

    .loop:
        jsr .compare    ; fits?
        bcs .end        ; if no, end.
        lda [$00]       ; else, keep going.
        beq .cmd        ; command, space or char?
        cmp #$ff        ; if space,
        beq .compare    ; test width one last time.
        bra .char       ;
    .compare:
        lda $03
        cmp !textie_arg_width
        bne .end
        clc
    .end:
        rts

    .cmd:

        ; get command index
        ldy #$01
        lda [$00],y
        asl #3
        tax
        ; ignore?
        lda.w command_list+3,x
        bit #$04
        bne +
        ; end ?
        bit #$02
        bne .compare

        ; run command (wrap)
        iny
        phx
        jsr.w (command_list+4,x)
        plx

        +

        ; move pointer
        lda #$00
        xba
        lda.w command_list+2,x
        inc #2
        rep #$20
        clc
        adc $00
        sta $00
        sep #$20

        bra .loop

    .char:

        ; add char width and postchar space
        tay
        lda [$04],y
        clc
        adc $03
        clc
        adc $07
        sta $03

        ; move pointer
        rep #$20
        inc $00
        sep #$20

        bra .loop

namespace off