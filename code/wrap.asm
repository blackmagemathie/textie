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
        tax
        ; ignore?
        lda.l command_index_flag,x
        bit #$04
        bne ..noRun
        ; end ?
        bit #$02
        bne .compare

        ; run command (wrap)
        iny
        phx
        lda.l command_index_wrap_lo,x
        sta.w !textie_command_abs+0
        lda.l command_index_wrap_hi,x
        sta.w !textie_command_abs+1
        pea.w +
        jmp.w (!textie_command_abs)
        +
        nop
        plx

        ..noRun

        ; move pointer
        lda #$00
        xba
        lda.l command_index_narg,x
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