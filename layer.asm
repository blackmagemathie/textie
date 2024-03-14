namespace layer

reserve:
    ; saves layer 3 image behavior, then adjusts it for messages.
    ; ----------------
    rep #$20
    lda $22 : sta !layerBackupBehavior+$00
    lda $24 : sta !layerBackupBehavior+$02
    lda $1458|!addr : sta !layerBackupBehavior+$04
    lda $145a|!addr : sta !layerBackupBehavior+$06
    lda $145c|!addr : sta !layerBackupBehavior+$0e
    sep #$20
    lda $40 : sta !layerBackupBehavior+$08
    lda $5b : sta !layerBackupBehavior+$09
    lda $145f|!addr : sta !layerBackupBehavior+$0a
    lda $145e|!addr : sta !layerBackupBehavior+$0b
    lda $1be3|!addr : sta !layerBackupBehavior+$0c
    lda $1403|!addr : sta !layerBackupBehavior+$0d
    lda $1460|!addr : sta !layerBackupBehavior+$10
    lda $13d5|!addr : sta !layerBackupBehavior+$11
    lda $3e : sta !layerBackupBehavior+$12
    rep #$20                    ;
    lda #$0100                  ; set position
    sta $22                     ;
    dec                         ;
    sta $24                     ;
    stz $1458|!addr             ; set speed
    stz $145a|!addr             ;
    stz $145c|!addr             ; kill pos x update
    sep #$20                    ;
    lda #$04 : trb $40          ; kill translucency
    lda #$80 : trb $5b          ; kill tide interaction
    stz $145f|!addr             ; kill scrolling settings
    lda #$07 : sta $145e|!addr  ; adjust layer settings
    stz $1be3|!addr             ; kill tides
    stz $1403|!addr             ;
    stz $1460|!addr             ; adjust layer direction
    stz $13d5|!addr             ; kill screen scroll
    lda #$08 : tsb $3e          ; adjust layer priority
    rts

release:
    ; restores layer 3 image behavior.
    ; ----------------
    rep #$20
    lda !layerBackupBehavior+$00 : sta $22
    lda !layerBackupBehavior+$02 : sta $24
    lda !layerBackupBehavior+$04 : sta $1458|!addr
    lda !layerBackupBehavior+$06 : sta $145a|!addr
    lda !layerBackupBehavior+$0e : sta $145c|!addr
    sep #$20
    lda !layerBackupBehavior+$08 : sta $40
    lda !layerBackupBehavior+$09 : sta $5b
    lda !layerBackupBehavior+$0a : sta $145f|!addr
    lda !layerBackupBehavior+$0b : sta $145e|!addr
    lda !layerBackupBehavior+$0c : sta $1be3|!addr
    lda !layerBackupBehavior+$0d : sta $1403|!addr
    lda !layerBackupBehavior+$10 : sta $1460|!addr
    lda !layerBackupBehavior+$11 : sta $13d5|!addr
    lda !layerBackupBehavior+$12 : sta $3e
    rts
    
transferBackup:
    ; preserves/restores layer 3 gfx/tilemap to/from buffer.
    ; ----------------
    ; carry            -> clear = restore; set = preserve.
    ; !argPosGfx (2)   -> gfx position.
    ; !tileCounter (2) -> how many 8x8 tiles to transfer.
    ; ----------------
    ldy !qutie_index                ; get index
    lda.b #!qutie_queue_page        ; adjust sas
    sta $2225                       ;
    lda #$00                        ; transfer type
    rol                             ;
    sta.w !qutie_type,y             ;
    rep #$20                        ; source
    lda !argPosGfxLo                ;
    asl #3                          ;
    pha                             ;
    asl                             ;
    clc                             ;
    adc.w #!layerBackupGfx          ;
    sep #$20                        ;
    sta.w !qutie_ram_lo,y           ;
    xba                             ;
    sta.w !qutie_ram_hi,y           ;
    lda.b #(!layerBackupGfx>>16)    ;
    sta.w !qutie_ram_bk,y           ;
    rep #$20                        ; transfer size
    lda !tileCounterLo              ;
    asl #4                          ;
    sep #$20                        ;
    sta.w !qutie_size_lo,y          ;
    xba                             ;
    sta.w !qutie_size_hi,y          ;
    rep #$20                        ; vram location
    pla                             ;
    clc                             ;
    adc #$4000                      ;
    sep #$20                        ;
    sta.w !qutie_gp_lo,y            ;
    xba                             ;
    sta.w !qutie_gp_hi,y            ;
    stz $2225                       ; restore sas
    inc !qutie_index                ; next queue index
    rts

namespace off