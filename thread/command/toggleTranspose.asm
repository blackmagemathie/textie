namespace toggleTranspose

; de/activates char color transposition.
; ----------------
; arg. 0 <- format : -------o
;           o = on/off

main:
    lda [$00],y
    lsr
    lda #$80
    bcc +
    tsb !charOptions
    rts
    +
    trb !charOptions
    rts

namespace off