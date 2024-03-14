namespace newLine

; start a new line.

main:
    stz $2250               ; set gfx position
    lda !caretPosNextFill   ;
    sec                     ;
    sbc !linePosScreenX     ;
    sta $2251               ;
    stz $2252               ;
    lda !fontHeight         ;
    inc                     ;
    sta $2253               ;
    stz $2254               ;
    rep #$20                ;
    nop                     ;
    lda $2306               ;
    clc                     ;
    adc !linePosGfxLo       ;
    sta !linePosGfxLo       ;
    sep #$20                ;
    lda !messagePosScreenX  ; set screen and col position
    sta !linePosScreenX     ;
    sta !caretPosScreenX    ;
    sta !caretPosNextFill   ;
    lda !linePosScreenY     ;
    sec                     ;
    adc !fontHeight         ;
    sta !linePosScreenY     ;
    lda !messagePosCol      ;
    sta !linePosCol         ;
    sta !caretPosCol        ;
    lda #$40                ; clear word flag
    trb !lineOptions        ;
    rts

namespace off