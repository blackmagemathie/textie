namespace setSpaceRegular

; sets regular space width.
; ----------------
; arg. 0 <- space width

main:
    lda [$00],y
    sta !spaceRegular
    rts

namespace off