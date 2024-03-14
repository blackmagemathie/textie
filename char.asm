namespace char

getWidth:
    ; gets a char's width in pixels.
    ; ----------------
    ; !charId -> char id.
    ; ----------------
    ; !charWidth <- char width.
    ; A          <- char width.
    ; $00-$02    <- (garbage)
    ; ----------------
    rep #$20            ; get char width
    lda !fontWidthsLo   ;
    sta $00             ;
    sep #$20            ;
    lda !fontDataBk     ;
    sta $02             ;
    ldy !charId         ;
    lda [$00],y         ;
    sta !charWidth      ;
    rts                 ;
    
draw:
    ; draws a single character in canvas. (wip)
    ; > kill new tile counter
    ; ----------------
    ; !charId        -> char to draw.
    ; !charWidth     -> char width.
    ; !argPosGfx (3) -> canvas position.
    ; !charOptions   -> options for drawn char.
    ; ----------------
    ; $00-$09 <- (garbage)
    ; ----------------
    lda !charWidth      ; get char dimensions
    bne +               ;
    rts                 ;
    +                   ;
    sta $00             ;
    lda !fontHeight     ;
    inc                 ;
    asl #3              ;
    sta $01             ;
    lda #$82            ; setup barrel shift
    sta $2258           ;
    lda !fontDataBk     ;
    sta $04             ;
    rep #$30            ;
    lda !charId         ;
    and #$00ff          ;
    asl                 ;
    tay                 ;
    lda !fontIndicesLo  ;
    sta $02             ;
    lda [$02],y         ;
    clc                 ;
    adc !fontGfxLo      ;
    sta $2259           ;
    sep #$30            ;
    lda !fontDataBk     ;
    sta $225b           ;
    rep #$20                    ; setup canvas pos
    lda !argPosGfxLo            ;
    asl #6                      ;
    sta $02                     ;
    sep #$20                    ;
    lda !argPosCol              ;
    and #$07                    ;
    tsb $02                     ;
    lda.b #!canvasVirtual>>16   ;
    sta $06                     ;
    ldx !fontHeight     ; setup tile step
    lda.l .tileStep,x   ;
    sta $08             ;
    lda !charOptions    ; setup char options
    and #$c0            ;
    ora #$03            ;
    sta $09             ;
    ; stz !charNewTiles   ; reset new tile counter
    .loopCols:
        rep #$20    ; copy canvas pos
        lda $02     ;
        sta $04     ;
        sep #$20    ;
        ldx $01     ; set col height
        ..loopPixels:
            lda $230d               ; get pixel color
            and #$03                ;
            bit $09                 ; transpose colors?
            bpl +                   ; if no, skip
            tay                     ;
            lda !charTranspose0,y   ;
            +                       ; process transparency?
            bvc ...write            ; if no, write
            beq ...noWrite          ; if yes and 0, don't write
            ...write:               ;
            sta [$04]               ; write color
            ...noWrite:             ;
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
        bne ++              ; if no, skip
        clc                 ; if yes, do
        adc $08             ;
        sta $02             ;
        bcc +               ;
        inc $03             ;
        +                   ;
        ; inc !charNewTiles   ; and bump new tile counter
        ++                  ; continue
        dec $00             ; cols done?
        bne .loopCols       ;
    .endCols:
    rts
    ; ----------------
    .tileStep:
    db $38,$78,$b8,$f8
    
namespace off
