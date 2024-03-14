namespace setLeadingSpaceSkip

; de/activates leading space skip.
; ----------------
; arg. 0 <- format : -------o
;           o = on/off

main:
    lda [$00],y
    lsr
    lda #$20
    bcc +
    tsb !lineOptions
    rts
    +
    trb !lineOptions
    rts

namespace off