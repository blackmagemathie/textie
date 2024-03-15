namespace layer

lm_preserve:
    ; preserves layer 3 lm settings.
    ; ----------------
    rep #$20
    lda $22 : sta !textie_layer_backup_lm+$00
    lda $24 : sta !textie_layer_backup_lm+$02
    lda $1458|!addr : sta !textie_layer_backup_lm+$04
    lda $145a|!addr : sta !textie_layer_backup_lm+$06
    lda $145c|!addr : sta !textie_layer_backup_lm+$0e
    sep #$20
    lda $40 : sta !textie_layer_backup_lm+$08
    lda $5b : sta !textie_layer_backup_lm+$09
    lda $145f|!addr : sta !textie_layer_backup_lm+$0a
    lda $145e|!addr : sta !textie_layer_backup_lm+$0b
    lda $1be3|!addr : sta !textie_layer_backup_lm+$0c
    lda $1403|!addr : sta !textie_layer_backup_lm+$0d
    lda $1460|!addr : sta !textie_layer_backup_lm+$10
    lda $13d5|!addr : sta !textie_layer_backup_lm+$11
    lda $3e : sta !textie_layer_backup_lm+$12
    rts
    
lm_set:
    ; adjusts layer 3 lm settings for messages.
    ; ----------------
    rep #$20
    lda #$0100                  ; set position.
    sta $22                     ;
    dec                         ;
    sta $24                     ;
    stz $1458|!addr             ; set speed.
    stz $145a|!addr             ;
    stz $145c|!addr             ; kill pos x update.
    sep #$20                    ;
    lda #$04 : trb $40          ; kill translucency.
    lda #$80 : trb $5b          ; kill tide interaction.
    stz $145f|!addr             ; kill scrolling settings.
    lda #$07 : sta $145e|!addr  ; adjust layer settings.
    stz $1be3|!addr             ; kill tides.
    stz $1403|!addr             ;
    stz $1460|!addr             ; adjust layer direction.
    stz $13d5|!addr             ; kill screen scroll.
    lda #$08 : tsb $3e          ; set layer 3 priority.
    rts

lm_restore:
    ; restores layer 3 lm settings.
    ; ----------------
    rep #$20
    lda !textie_layer_backup_lm+$00 : sta $22
    lda !textie_layer_backup_lm+$02 : sta $24
    lda !textie_layer_backup_lm+$04 : sta $1458|!addr
    lda !textie_layer_backup_lm+$06 : sta $145a|!addr
    lda !textie_layer_backup_lm+$0e : sta $145c|!addr
    sep #$20
    lda !textie_layer_backup_lm+$08 : sta $40
    lda !textie_layer_backup_lm+$09 : sta $5b
    lda !textie_layer_backup_lm+$0a : sta $145f|!addr
    lda !textie_layer_backup_lm+$0b : sta $145e|!addr
    lda !textie_layer_backup_lm+$0c : sta $1be3|!addr
    lda !textie_layer_backup_lm+$0d : sta $1403|!addr
    lda !textie_layer_backup_lm+$10 : sta $1460|!addr
    lda !textie_layer_backup_lm+$11 : sta $13d5|!addr
    lda !textie_layer_backup_lm+$12 : sta $3e
    rts
    
vram_transfer:
    ; preserves/restores layer 3 vram data to/from buffer.
    ; ----------------
    ; carry                        -> clear = restore; set = preserve.
    ; !textie_arg_pos_gfx (2)      -> gfx position.
    ; !textie_arg_tile_counter (2) -> how many 8x8 tiles to transfer.
    ; ----------------
    ldy !qutie_index                        ; get index
    lda.b #!qutie_queue_page                ; adjust sas
    sta $2225                               ;
    lda #$00                                ; transfer type
    rol                                     ;
    sta.w !qutie_type,y                     ;
    rep #$20                                ; source
    lda !textie_arg_pos_gfx_lo              ;
    asl #3                                  ;
    pha                                     ;
    asl                                     ;
    clc                                     ;
    adc.w #!textie_layer_backup_gfx         ;
    sep #$20                                ;
    sta.w !qutie_ram_lo,y                   ;
    xba                                     ;
    sta.w !qutie_ram_hi,y                   ;
    lda.b #(!textie_layer_backup_gfx>>16)   ;
    sta.w !qutie_ram_bk,y                   ;
    rep #$20                                ; transfer size
    lda !textie_arg_tile_counter_lo         ;
    asl #4                                  ;
    sep #$20                                ;
    sta.w !qutie_size_lo,y                  ;
    xba                                     ;
    sta.w !qutie_size_hi,y                  ;
    rep #$20                                ; vram location
    pla                                     ;
    clc                                     ;
    adc #$4000                              ;
    sep #$20                                ;
    sta.w !qutie_gp_lo,y                    ;
    xba                                     ;
    sta.w !qutie_gp_hi,y                    ;
    stz $2225                               ; restore sas
    inc !qutie_index                        ; next queue index
    rts

namespace off