namespace setSpacePostchar

; sets postchar space width.
; ----------------
; arg. 0 <- space width (in px, signed).

main:
    lda [$00],y
    sta !textie_space_postchar
    rts
    
wrap:
    lda [$00],y
    sta $07
    rts

namespace off