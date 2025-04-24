main:
    lda [$00],y
    sta !textie_space_postchar
    rts
    
wrap:
    lda [$00],y
    sta $07
    rts
    