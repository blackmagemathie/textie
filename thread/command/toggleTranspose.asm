namespace toggleTranspose

; toggles char color transposition.
; ----------------
; arg. 0 <- format : -------o
;           o = on/off.

main:
    lda [$00],y
    lsr
    lda #$80
    bcc +
    tsb !textie_char_option
    rts
    +
    trb !textie_char_option
    rts

namespace off