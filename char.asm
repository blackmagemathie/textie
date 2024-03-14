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
    lda !textie_font_widths_lo
    sta $00
    sep #$20
    lda !textie_font_data_bk
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
    lda !textie_char_width          ; get char dimensions.
    bne +                           ;
    rts                             ;
    +                               ;
    sta $00                         ;
    lda !textie_font_height         ;
    inc                             ;
    asl #3                          ;
    sta $01                         ;
    lda #$82                        ; setup barrel shift
    sta $2258                       ;
    lda !textie_font_data_bk        ;
    sta $04                         ;
    rep #$30                        ;
    lda !textie_char_id             ;
    and #$00ff                      ;
    asl                             ;
    tay                             ;
    lda !textie_font_indices_lo     ;
    sta $02                         ;
    lda [$02],y                     ;
    clc                             ;
    adc !textie_font_gfx_lo         ;
    sta $2259                       ;
    sep #$30                        ;
    lda $04                         ;
    sta $225b                       ;
    rep #$20                        ; setup canvas pos
    lda !textie_arg_pos_gfx_lo      ;
    asl #6                          ;
    sta $02                         ;
    sep #$20                        ;
    lda !textie_arg_pos_col         ;
    and #$07                        ;
    tsb $02                         ;
    lda.b #!textie_canvas_bmp>>16   ;
    sta $06                         ;
    ldx !textie_font_height         ; get tile step.
    lda.l .tileStep,x               ;
    sta $08                         ;
    lda !textie_char_option         ; get and clean char option.
    and #$c0                        ;
    ora #$03                        ;
    sta $09                         ;
    .loopCols:
        rep #$20    ; copy canvas pos
        lda $02     ;
        sta $04     ;
        sep #$20    ;
        ldx $01     ; set col height
        ..loopPixels:
            lda $230d                       ; get pixel color
            and #$03                        ;
            bit $09                         ; transpose colors?
            bpl +                           ; if no, skip
            tay                             ;
            lda !textie_char_transpose,y    ;
            +                               ; process transparency?
            bvc ...write                    ; if no, write
            beq ...noWrite                  ; if yes and 0, don't write
            ...write:                       ;
            sta [$04]                       ; write color
            ...noWrite:                     ;
            dex                 ; pixels done?
            beq ..endPixels     ;
            lda $04             ; if no, continue
            clc                 ;
            adc #$08            ;
            sta $04             ;
            bcc ..loopPixels    ;
            inc $05             ;
            bra ..loopPixels    ;
        ..endPixels:
        rep #$20            ; if no, next one
        inc $02             ;
        sep #$20            ;
        lda $02             ; step tile?
        bit #$07            ;
        bne +               ; if no, skip
        clc                 ; if yes, do
        adc $08             ;
        sta $02             ;
        bcc +               ;
        inc $03             ;
        +                   ; continue
        dec $00             ; cols done?
        bne .loopCols       ;
    .endCols:
    rts
    ; ----------------
    .tileStep:
    db $38,$78,$b8,$f8

namespace off
