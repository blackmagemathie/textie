normal:

    ; set bitmap mode
    lda #$80
    sta $223f
    .readChar:

    ; get message pointer.
    rep #$20
    lda !textie_message_pointer
    sta $00
    sep #$20
    lda !textie_message_pointer+2
    sta $02

    ; command, space or char?
    lda [$00]
    beq .cmd
    cmp #$ff
    beq .space
    jmp .char

    .cmd:

        ; x <- command index
        ldy #$01
        lda [$00],y
        tax

        ; run command main
        iny
        phx
        lda.l command_index_main_lo,x
        sta.w !textie_command_abs+0
        lda.l command_index_main_hi,x
        sta.w !textie_command_abs+1
        pea.w +
        jmp.w (!textie_command_abs)
        +
        nop
        plx

        ; move message pointer
        lda #$00
        xba
        lda.l command_index_narg,x
        inc #2
        rep #$20
        clc
        adc !textie_message_pointer
        sta !textie_message_pointer
        sep #$20

        ; chain if possible
        lda.w !textie_thread_flags
        bit.b #!textie_thread_flag_chain_commands
        beq +
            lda.l command_index_flag,x
            bit #$01
            bne .readChar
        +

        rts

    .space:

        ; skip leading spaces?
        lda.w !textie_line_option
        and.b #(!textie_line_flag_lead_skip+!textie_line_flag_in_lead)
        cmp.b #(!textie_line_flag_lead_skip+!textie_line_flag_in_lead)
        beq +

        ; move caret
        lda !textie_space_regular
        sta !textie_arg_move
        jsr util_moveCaret

        ; word wrap enabled?
        lda.w !textie_line_option
        bit.b #!textie_line_flag_wrap
        beq +

        lda !textie_line_pos_screen_x
        asl #3
        ora !textie_line_pos_col
        clc
        adc !textie_line_width
        sta $00
        lda !textie_caret_pos_screen_x
        asl #3
        ora !textie_caret_pos_col
        cmp $00
        bcc +
        jsr util_breakLine

        +

        ; move message pointer
        rep #$20
        inc !textie_message_pointer
        sep #$20

        ; clear "word"
        lda.b #!textie_line_flag_in_word
        trb.w !textie_line_option

        ; chain if possible
        lda.w !textie_thread_flags
        bit.b #!textie_thread_flag_chain_spaces
        beq +
            jmp .readChar
        +

        rts

    .char:

        ..width:

            ; get char width
            sta !textie_char_id
            jsr char_getWidth
            ; end early if null
            bne +
            rep #$20
            inc !textie_message_pointer
            sep #$20
            rts
            +

        ..wrap:

            ; enabled?
            lda.w !textie_line_option
            bit.b #!textie_line_flag_wrap
            beq ...skip

            ; word flag clear?
            bit.b #!textie_line_flag_in_word
            bne ...skip

            ; get caret pos
            lda !textie_caret_pos_screen_x
            asl #3
            ora !textie_caret_pos_col
            sta $03

            ; get line end pos
            lda !textie_line_pos_screen_x
            asl #3
            ora !textie_line_pos_col
            clc
            adc !textie_line_width

            ; get max width
            sec
            sbc $03
            sta !textie_arg_width

            ; get message pointer
            rep #$20
            lda !textie_message_pointer
            sta $00
            sep #$20
            lda !textie_message_pointer+2
            sta $02

            ; break line if needed
            jsr wrap_testWord
            bcc ...skip
            jsr util_breakLine

            ...skip

        ..bgFill:

            ; simulate caret movement
            lda !textie_caret_pos_screen_x
            asl #3
            ora !textie_caret_pos_col
            clc
            adc !textie_char_width
            sta $01
            lsr #3
            sta $00
            lda #$f8
            trb $01

            ; before fill?
            lda $00
            cmp !textie_caret_pos_fill
            bcc ...skip

            ; count tiles to fill
            lda $01
            beq +
            lda #$01
            +
            clc
            adc $00
            sec
            sbc !textie_caret_pos_fill
            beq ...skip
            pha

            ; autofill enabled?
            lda.w !textie_line_option
            and.b #!textie_line_flag_autofill
            beq ...noFill

            ; get exact tile count
            lda $01,s
            stz $2250
            sta $2251
            stz $2252
            lda !textie_font_height
            inc
            sta $2253
            stz $2254
            nop #3
            lda $2306
            sta !textie_arg_tile_counter

            ; get gfx pos
            stz $2250
            lda !textie_caret_pos_fill
            sec
            sbc !textie_line_pos_screen_x
            sta $2251
            stz $2252
            lda !textie_font_height
            inc
            sta $2253
            stz $2254
            rep #$20
            lda !textie_line_pos_gfx
            clc
            adc $2306
            sta !textie_arg_pos_gfx
            sep #$20

            jsr background_draw

            ...noFill

            pla
            clc
            adc !textie_caret_pos_fill
            sta !textie_caret_pos_fill

            ...skip

        ..drawChar:

            stz $2250
            lda !textie_caret_pos_screen_x
            sec
            sbc !textie_line_pos_screen_x
            sta $2251
            stz $2252
            lda !textie_font_height
            inc
            sta $2253
            stz $2254
            rep #$20
            lda !textie_line_pos_gfx
            clc
            adc $2306
            sta !textie_arg_pos_gfx
            sep #$20
            lda !textie_caret_pos_col
            sta !textie_arg_pos_col
            jsr char_draw

        ..uploadCanvas:

            lda !textie_caret_pos_col
            and #$07
            clc
            adc !textie_char_width
            pha
            lsr #3
            sta $00
            pla
            and #$07
            beq +
            inc $00
            +
            stz $2250
            lda $00
            sta $2251
            stz $2252
            lda !textie_font_height
            inc
            sta $2253
            stz $2254
            rep #$20
            nop
            lda $2306
            sta !textie_arg_tile_counter
            sep #$20
            jsr canvas_upload

        ..layText:

            rep #$20
            lda !textie_line_pos_screen_y-1
            and #$ff00
            lsr #3
            sep #$20
            ora !textie_caret_pos_screen_x
            rep #$20
            sta !textie_arg_tilemap_pos
            sep #$20
            lda $00
            sta !textie_arg_tile_counter
            sta !textie_arg_tile_priority
            jsr tilemap_layText

        ..uploadTilemap:

            lda #$03
            sta !textie_arg_quarter
            lda !textie_font_height
            inc
            sta !textie_arg_rows
            jsr tilemap_upload

        ..moveCaret:

            lda !textie_char_width
            clc
            adc !textie_space_postchar
            sta !textie_arg_move
            jsr util_moveCaret

        ..finish:

            ; set "word"
            lda.b #!textie_line_flag_in_word
            tsb.w !textie_line_option

            ; clear "in lead"
            lda.b #!textie_line_flag_in_lead
            trb.w !textie_line_option

            ; move message pointer.
            rep #$20
            inc.w !textie_message_pointer
            sep #$20

        rts