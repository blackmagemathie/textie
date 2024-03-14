namespace setSpaceRegular

; sets regular space width.
; ----------------
; arg. 0 <- space width (in px, signed).

main:
    lda [$00],y
    sta !textie_space_regular
    rts

namespace off