namespace setCharPalette

; sets palette of char tiles.
; ----------------
; arg. 0 <- palette ($00-$07).

main:
    lda [$00],y
    and #$07
    sta !textie_char_palette
    rts

namespace off