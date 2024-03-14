namespace background

draw:
    ; fills canvas with background gfx. (wip)
    ; > optimise for plain colors (0 to 3)
    ; ----------------
    ; !argPosGfx (2)   -> canvas position.
    ; !tileCounter (1) -> how many 8x8 tiles to fill.
    ; !backgroundId    -> id of background to use.
    ; ----------------
    lda !tileCounterLo  ; set tile counter
    bne +               ;
    rts                 ;
    +                   ;
    sta $3100           ;
    rep #$30            ; get index
    lda !argPosGfxLo    ;
    asl #4              ;
    tay                 ;
    lda !backgroundId                   ; buffer background gfx
    and #$00ff                          ;
    asl #4                              ;
    tax                                 ;
    lda.l backgrounds+$0,x : sta $00    ;
    lda.l backgrounds+$2,x : sta $02    ;
    lda.l backgrounds+$4,x : sta $04    ;
    lda.l backgrounds+$6,x : sta $06    ;
    lda.l backgrounds+$8,x : sta $08    ;
    lda.l backgrounds+$a,x : sta $0a    ;
    lda.l backgrounds+$c,x : sta $0c    ;
    lda.l backgrounds+$e,x : sta $0e    ;
    tyx                                 ;
    -
    lda $00 : sta.l !canvas+$0,x        ; fill a tile
    lda $02 : sta.l !canvas+$2,x        ;
    lda $04 : sta.l !canvas+$4,x        ;
    lda $06 : sta.l !canvas+$6,x        ;
    lda $08 : sta.l !canvas+$8,x        ;
    lda $0a : sta.l !canvas+$a,x        ;
    lda $0c : sta.l !canvas+$c,x        ;
    lda $0e : sta.l !canvas+$e,x        ;
    sep #$20    ; done?
    dec $3100   ;
    beq +       ;
    rep #$20    ; if not, increase index,
    txa         ;
    clc         ;
    adc #$0010  ;
    tax         ;
    bra -       ; and keep going.
    +           ;
    sep #$10    ;
    rts
    
namespace off
