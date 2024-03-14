namespace toggleWrap

; de/activates word wrap.
; ----------------
; arg. 0 <- format : -------o
;           o = on/off

main:
    lda [$00],y
    lsr
    lda #$80
    bcc +
    tsb !lineOptions
    rts
    +
    trb !lineOptions
    rts

namespace off