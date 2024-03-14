namespace setTransposeTable

; sets transposition table.
; ----------------
; arg. 0-3 <- transposition values (0 to 3)

main:
    lda [$00],y : sta !charTranspose0 : iny
    lda [$00],y : sta !charTranspose1 : iny
    lda [$00],y : sta !charTranspose2 : iny
    lda [$00],y : sta !charTranspose3
    rts

namespace off