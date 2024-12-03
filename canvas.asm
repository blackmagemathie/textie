namespace canvas

upload:
    ; uploads canvas gfx to vram.
    ; ----------------
    ; !textie_arg_pos_gfx (2)      -> vram/canvas pos
    ; !textie_arg_tile_counter (2) -> how many 8px tiles to upload
    ; ----------------

    ; get qutie index
    ldy !qutie_index

    ; adjust sas mapping
    lda.b #!qutie_queue_page
    sta $318f
    sta $2225

    ; set transfer type
    lda #$04
    sta.w !qutie_type,y

    ; set ccdma settings
    lda #$02
    sta.w !qutie_cc_params,y

    ; set transfer size
    rep #$20
    lda !textie_arg_tile_counter
    asl #4
    sep #$20
    sta.w !qutie_size_lo,y
    xba
    sta.w !qutie_size_hi,y

    ; set vram location
    rep #$20
    lda !textie_arg_pos_gfx
    asl #3
    pha
    clc
    adc #$4000
    sep #$20
    sta.w !qutie_gp_lo,y
    xba
    sta.w !qutie_gp_hi,y

    ; set source
    rep #$20
    pla
    asl
    clc
    adc.w #!textie_canvas
    sep #$20
    sta.w !qutie_ram_lo,y
    xba
    sta.w !qutie_ram_hi,y
    lda.b #(!textie_canvas>>16)
    adc #$00
    sta.w !qutie_ram_bk,y

    ; restore sas mapping
    stz $2225
    stz $318f

    ; update qutie index
    inc !qutie_index

    rts

namespace off