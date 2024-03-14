namespace header

read:
    ; reads a message header.
    ; ----------------
    ; $00-$02 <- pointer to header
    ; ----------------
    ldy #$00                ; set y
    lda [$00],y             ; get font
    sta !fontId             ;
    jsr font_load           ;
    iny                     ;
    lda [$00],y             ; get background
    sta !backgroundId       ;
    iny                     ;
    rep #$20                ; get screen and col position
    lda [$00],y             ;
    sta !messagePosScreenX  ;
    sta !linePosScreenX     ;
    sep #$20                ;
    sta !caretPosScreenX    ;
    sta !caretPosNextFill   ;
    iny #2                  ;
    lda [$00],y             ;
    sta !messagePosCol      ;
    sta !linePosCol         ;
    sta !caretPosCol        ;
    iny                     ;
    lda [$00],y             ; get line width
    sta !lineWidth          ;
    iny                     ;
    rep #$20                ; get starting gfx pos
    lda [$00],y             ;
    sta !messagePosGfxLo    ;
    sta !linePosGfxLo       ;
    sep #$20                ;
    iny #2                  ;
    lda [$00],y             ; get spaces
    sta !spacePostchar      ;
    iny                     ;
    lda [$00],y             ;
    sta !spaceRegular       ;
    iny                     ;
    lda [$00],y             ; get char palette
    sta !charPalette        ;
    iny                     ;
    lda [$00],y             ; get char options
    sta !charOptions        ;
    iny                     ;
    lda [$00],y : sta !charTranspose0 : iny ; get color transposition
    lda [$00],y : sta !charTranspose1 : iny ;
    lda [$00],y : sta !charTranspose2 : iny ;
    lda [$00],y : sta !charTranspose3 : iny ;
    rts

namespace off