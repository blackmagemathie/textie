namespace setBackground

; sets background to generate below chars.
; ----------------
; arg. 0 <- background id

main:
    lda [$00],y
    sta !textie_background_id
    rts

namespace off