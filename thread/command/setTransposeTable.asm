namespace setTransposeTable

; sets transposition table.
; ----------------
; arg. 0-3 <- transposition table ($00 to $03).

main:
    lda [$00],y : sta !textie_char_transpose+0 : iny
    lda [$00],y : sta !textie_char_transpose+1 : iny
    lda [$00],y : sta !textie_char_transpose+2 : iny
    lda [$00],y : sta !textie_char_transpose+3
    rts

namespace off