namespace setBackground

; sets background to generate below chars.
; ----------------
; arg. 0 <- background id

main:
    lda [$00],y
    sta !backgroundId
    rts

namespace off