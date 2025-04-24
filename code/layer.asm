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
    lda $0d9d|!addr : sta !textie_layer_backup_lm+$13

    rts

lm_set:
    ; adjusts layer 3 lm settings for messages.
    ; ----------------

    rep #$20
    ; set position.
    lda #$0100
    sta $22
    dec
    sta $24
    ; set speed.
    stz $1458|!addr
    stz $145a|!addr
    ; kill pos x update.
    stz $145c|!addr
    sep #$20
    ; kill translucency.
    lda #$04
    trb $40
    ; kill tide interaction.
    lda #$80
    trb $5b
    ; kill scrolling settings.
    stz $145f|!addr
    ; adjust layer settings.
    lda #$07
    sta $145e|!addr
    ; kill tides.
    stz $1be3|!addr
    stz $1403|!addr
    ; adjust layer direction.
    stz $1460|!addr
    ; kill screen scroll.
    stz $13d5|!addr
    ; set layer 3 priority.
    lda #$08
    tsb $3e
    ; update main screen
    lda #$04
    tsb $0d9d|!addr
    lda.b #!textie_nmi_flag_update_main_screen
    tsb.w !textie_nmi_flags

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
    lda !textie_layer_backup_lm+$13 : sta $0d9d|!addr
    lda.b #!textie_nmi_flag_update_main_screen
    tsb.w !textie_nmi_flags
    rts

vram_transfer:
    ; preserves/restores layer 3 vram data to/from buffer.
    ; ----------------
    ; carry                        -> clear = restore; set = preserve.
    ; !textie_arg_pos_gfx (2)      -> gfx position.
    ; !textie_arg_tile_counter (2) -> how many 8x8 tiles to transfer.
    ; ----------------
    ; get qutie index.
    ldy !qutie_index

    ; adjust sas mapping.
    lda.b #!qutie_queue_page
    sta $318f
    sta $2225

    ; set transfer type.
    lda #$00
    rol
    sta.w !qutie_type,y

    ; set source.
    rep #$20
    lda !textie_arg_pos_gfx
    asl #3
    pha
    asl
    clc
    adc.w #!textie_layer_backup_gfx
    sep #$20
    sta.w !qutie_ram_lo,y
    xba
    sta.w !qutie_ram_hi,y
    lda.b #(!textie_layer_backup_gfx>>16)
    sta.w !qutie_ram_bk,y

    ; set transfer size.
    rep #$20
    lda !textie_arg_tile_counter
    asl #4
    sep #$20
    sta.w !qutie_size_lo,y
    xba
    sta.w !qutie_size_hi,y

    ; set vram pos.
    rep #$20
    pla
    clc
    adc #$4000
    sep #$20
    sta.w !qutie_gp_lo,y
    xba
    sta.w !qutie_gp_hi,y

    ; restore sas mapping.
    stz $2225
    stz $318f

    ; update qutie index.
    inc !qutie_index

    rts

namespace off