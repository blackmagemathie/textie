namespace setCharPalette

; sets palette of char tiles.
; ----------------
; arg. 0 <- palette (0-7)

main:
    lda [$00],y
    and #$07
    sta !charPalette
    rts

namespace off