namespace char

getWidth:
    ; returns a char's width (in px).
    ; ----------------
    ; textie_char_id -> char id.
    ; ----------------
    ; textie_char_width <- char width (in px).
    ; A                 <- char width (in px).
    ; $00-$02           <- pointer to font widths.
    ; ----------------
    rep #$20
    lda !textie_font_widths
    sta $00
    sep #$20
    lda !textie_font_bk
    sta $02
    ldy !textie_char_id
    lda [$00],y
    sta !textie_char_width
    rts

draw:
    ; draws a single character in canvas.
    ; ----------------
    ; !textie_char_id         -> char to draw.
    ; !textie_char_width      -> char width.
    ; !textie_arg_pos_gfx (3) -> canvas position.
    ; !textie_char_option     -> char option.
    ; ----------------
    ; $00-$09 <- (garbage)
    ; ----------------

    ; get char dimensions.
    lda !textie_char_width
    bne +
    rts
    +
    sta $00
    lda !textie_font_height
    inc
    asl #3
    sta $01

    ; setup barrel shift.
    lda #$82
    sta $2258
    lda !textie_font_bk
    sta $04
    rep #$30
    lda !textie_char_id
    and #$00ff
    asl
    tay
    lda !textie_font_indices
    sta $02
    lda [$02],y
    clc
    adc !textie_font_gfx
    sta $2259
    sep #$30
    lda $04
    sta $225b

    ; set canvas pos.
    rep #$20
    lda !textie_arg_pos_gfx
    asl #6
    sta $02
    sep #$20
    lda !textie_arg_pos_col
    and #$07
    tsb $02
    lda.b #!textie_canvas_bmp>>16
    sta $06

    ldx !textie_font_height ; get tile step.
    lda.l .tileStep,x       ;
    sta $08                 ;
    lda !textie_char_option ; get and clean char option.
    and #$c0                ;
    ora #$03                ;
    sta $09                 ;
    .loopCols:
        rep #$20    ; copy canvas pos.
        lda $02     ;
        sta $04     ;
        sep #$20    ;
        ldx $01     ; set col height.
        ..loopPixels:
            lda $230d                       ; get pixel color.
            and #$03                        ;
            bit $09                         ; transpose colors?
            bpl +                           ; if yes,
            tay                             ; use color as index,
            lda !textie_char_transpose,y    ; for transposition table.
            +                               ; process transparency?
            bvc ...write                    ; if no, write directly.
            beq ...noWrite                  ; if yes and 0, don't write.
            ...write:                       ;
            sta [$04]                       ; write color
            ...noWrite:                     ;
            dex                 ; pixels done?
            beq ..endPixels     ; if no,
            lda $04             ; move 1px down,
            clc                 ;
            adc #$08            ;
            sta $04             ;
            bcc ..loopPixels    ;
            inc $05             ;
            bra ..loopPixels    ; and keep going.
        ..endPixels:
        rep #$20        ; next col!
        inc $02         ;
        sep #$20        ;
        lda $02         ; step into new tile?
        bit #$07        ;
        bne +           ; if yes,
        clc             ; set new values.
        adc $08         ;
        sta $02         ;
        bcc +           ;
        inc $03         ;
        +               ;
        dec $00         ; cols done?
        bne .loopCols   ; if no, keep going.
    .endCols:
    rts
    ; ----------------
    .tileStep:
    db $38,$78,$b8,$f8

namespace off
