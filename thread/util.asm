namespace util

moveCaret:
    ; moves caret within line.
    ; ----------------
    ; !argMove <- horizontal movement (in px)
    ; ----------------
    lda !caretPosScreenX
    asl #3
    ora !caretPosCol
    clc
    adc !argMove
    sta !caretPosCol
    lsr #3
    sta !caretPosScreenX
    lda #$f8
    trb !caretPosCol
    rts

namespace off