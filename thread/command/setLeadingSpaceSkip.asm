namespace setLeadingSpaceSkip

; toggles skipping of leading spaces.
; ----------------
; arg. 0 <- format : -------o
;           o = on/off

main:
    lda [$00],y
    lsr
    lda #$20
    bcc +
    tsb !textie_line_option
    rts
    +
    trb !textie_line_option
    rts

namespace off