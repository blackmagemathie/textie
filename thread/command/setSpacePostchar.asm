namespace setSpacePostchar

; sets postchar space width.
; ----------------
; arg. 0 <- space width

main:
    lda [$00],y
    sta !spacePostchar
    rts
    
wrap:
    lda [$00],y
    sta $07
    rts

namespace off