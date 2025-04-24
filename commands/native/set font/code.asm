main:
    lda [$00],y
    sta !textie_font_id
    php
    jsr font_load
    plp
    rts
    
wrap:
    lda [$00],y
    rep #$30
    and #$00ff
    asl #3
    tax
    lda.l font_data_index+$01,x
    sta $04
    sep #$20
    lda.l font_data_index+$00,x
    sta $06
    sep #$10
    rts
    