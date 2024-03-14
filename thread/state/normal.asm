normal:
    ; executes thread normally. (wip)
    ; ----------------
    lda #$80    ; setup bitmap mode
    sta $223f   ;
    .readChar:
    rep #$20                        ; setup pointer
    lda !textie_message_pointer_lo  ;
    sta $00                         ;
    sep #$20                        ;
    lda !textie_message_pointer_bk  ;
    sta $02                         ;
    lda [$00]                       ; command, space or char?
    beq .cmd                        ;
    cmp #$ff                        ;
    beq .space                      ;
    bra .char                       ;
    ; ----------------
    .cmd:
        ldy #$01                        ; get command index
        lda [$00],y                     ;
        asl #3                          ;
        tax                             ;
        iny                             ; execute command (main routine)
        phx                             ;
        jsr (thread_command_list,x)     ;
        plx                             ;
        lda #$00                        ; move pointer
        xba                             ;
        lda.w thread_command_list+2,x   ;
        inc #2                          ;
        rep #$20                        ;
        clc                             ;
        adc !textie_message_pointer_lo
        sta !textie_message_pointer_lo
        sep #$20                        ;
        lda !textie_thread_option       ; if chaining enabled,
        bpl +                           ;
        lda.w thread_command_list+3,x   ; and command is chainable,
        bit #$01                        ;
        bne .readChar                   ; keep processing
        +                               ;
        rts
    ; ----------------
    .space:
        lda !textie_line_option         ; skip leading spaces?
        bit #$20                        ;
        beq +                           ;
        bit #$10                        ; if yes, and in leading spaces,
        beq ++                          ; skip
        +                               ;
            
        lda !textie_space_regular       ; move caret.
        sta !textie_arg_move            ;
        jsr thread_util_moveCaret       ;
            
        lda !textie_line_option         ; words wrap enabled?
        bpl +                           ;
        lda !textie_line_pos_screen_x   ; get line end pos
        asl #3                          ;
        ora !textie_line_pos_col        ;
        clc                             ;
        adc !textie_line_width          ;
        sta $00                         ;
        lda !textie_caret_pos_screen_x  ; get caret pos
        asl #3                          ;
        ora !textie_caret_pos_col       ;
        cmp $00                         ; if too far,
        bcc +                           ;
        jsr thread_command_newLine_main ; start new line
        +                               ;
        ++  
        rep #$20                        ; move pointer
        inc !textie_message_pointer_lo
        sep #$20                        ;
        lda #$40                        ; clear word flag
        trb !textie_line_option         ;
        lda !textie_thread_option       ; if chaining enabled,
        and #$40                        ;
        beq +                           ;
        jmp .readChar                   ; keep processing
        +                               ;
        rts
    ; ----------------
    .char:
        sta !textie_char_id             ; set char id.
        jsr char_getWidth               ; get char width.
        bne +                           ; zero? if yes,
        rep #$20                        ; move pointer,
        inc !textie_message_pointer_lo  ;
        sep #$20                        ;
        rts                             ; and return early.
        +                               ;
        
        lda !textie_line_option ; word wrap enabled?
        bpl +                   ; 
        bit #$40                ; word flag clear?
        bne +                   ;
        
        lda !textie_caret_pos_screen_x  ; get caret pos
        asl #3                          ;
        ora !textie_caret_pos_col       ;
        sta $03                         ;
        lda !textie_line_pos_screen_x   ; get line end pos
        asl #3                          ;
        ora !textie_line_pos_col        ;
        clc                             ;
        adc !textie_line_width          ;
        sec                             ; get max width
        sbc $03                         ;
        sta !textie_arg_width           ;
        rep #$20                        ; get pointer
        lda !textie_message_pointer_lo  ;
        sta $00                         ;
        sep #$20                        ;
        lda !textie_message_pointer_bk  ;
        sta $02                         ;
        jsr thread_wrap_testWord        ; test word
        bcc +
        jsr thread_command_newLine_main
        +
        
        lda !textie_caret_pos_screen_x  ; move caret in theory
        asl #3                          ;
        ora !textie_caret_pos_col       ;
        clc                             ;
        adc !textie_char_width          ;
        sta $01                         ;
        lsr #3                          ;
        sta $00                         ;
        lda #$f8                        ;
        trb $01                         ;
        lda $00                         ; before next fill?
        cmp !textie_caret_pos_fill      ;
        bcc ..noFill                    ;
        lda $01                         ; if no, get number of tiles to fill
        beq +                           ;
        lda #$01                        ;
        +                               ;
        clc                             ;
        adc $00                         ;
        sec                             ;
        sbc !textie_caret_pos_fill      ;
        beq ..noFill                    ; if zero, don't fill
        pha                             ; preserve number.
        lda !textie_line_option         ; auto background drawing disabled?
        and #$08                        ; if yes,
        bne +                           ; skip most of what follows.
        lda $01,s                       ; get exact tile count,
        stz $2250                       ;
        sta $2251                       ;
        stz $2252                       ;
        lda !textie_font_height         ;
        inc                             ;
        sta $2253                       ;
        stz $2254                       ;
        nop #3                          ;
        lda $2306                       ;
        sta !textie_arg_tile_counter_lo ;
        stz $2250                       ; get gfx pos,
        lda !textie_caret_pos_fill      ;
        sec                             ;
        sbc !textie_line_pos_screen_x   ;
        sta $2251                       ;
        stz $2252                       ;
        lda !textie_font_height         ;
        inc                             ;
        sta $2253                       ;
        stz $2254                       ;
        rep #$20                        ;
        lda !textie_line_pos_gfx_lo     ;
        clc                             ;
        adc $2306                       ;
        sta !textie_arg_pos_gfx_lo      ;
        sep #$20                        ;
        jsr background_draw             ; draw bg,
        +                               ;
        pla                             ; and move next fill trigger
        clc                             ;
        adc !textie_caret_pos_fill      ;
        sta !textie_caret_pos_fill      ;
        ..noFill:

        stz $2250                       ; draw char
        lda !textie_caret_pos_screen_x  ;
        sec                             ;
        sbc !textie_line_pos_screen_x   ;
        sta $2251                       ;
        stz $2252                       ;
        lda !textie_font_height         ;
        inc                             ;
        sta $2253                       ;
        stz $2254                       ;
        rep #$20                        ;
        lda !textie_line_pos_gfx_lo     ;
        clc                             ;
        adc $2306                       ;
        sta !textie_arg_pos_gfx_lo      ;
        sep #$20                        ;
        lda !textie_caret_pos_col       ;
        sta !textie_arg_pos_col         ;
        jsr char_draw                   ;
        
        lda !textie_caret_pos_col       ; upload gfx
        and #$07                        ;
        clc                             ;
        adc !textie_char_width          ;
        pha                             ;
        lsr #3                          ;
        sta $00                         ;
        pla                             ;
        and #$07                        ;
        beq +                           ;
        inc $00                         ;
        +                               ;
        stz $2250                       ;
        lda $00                         ;
        sta $2251                       ;
        stz $2252                       ;
        lda !textie_font_height         ;
        inc                             ;
        sta $2253                       ;
        stz $2254                       ;
        rep #$20                        ;
        nop                             ;
        lda $2306                       ;
        sta !textie_arg_tile_counter_lo ;
        sep #$20                        ;
        jsr canvas_upload               ;

        rep #$20                        ; write to tilemap
        lda !textie_line_pos_screen_y-1 ;
        and #$ff00                      ;
        lsr #3                          ;
        sep #$20                        ;
        ora !textie_caret_pos_screen_x  ;
        rep #$20                        ;
        sta !textie_arg_tilemap_pos_lo  ;
        sep #$20                        ;
        lda $00                         ;
        sta !textie_arg_tile_counter_lo ;
        sta !textie_arg_tile_priority   ;
        jsr tilemap_layText             ;

        lda #$03                ; upload tilemap
        sta !textie_arg_quarter ;
        lda !textie_font_height ;
        inc                     ;
        sta !textie_arg_rows    ;
        jsr tilemap_upload      ;

        lda !textie_char_width          ; move caret
        clc                             ;
        adc !textie_space_postchar      ;
        sta !textie_arg_move            ;
        jsr thread_util_moveCaret       ;
        lda #$50                        ; set word flag, and out-of-leading-spaces flag
        tsb !textie_line_option         ;
        rep #$20                        ; move pointer
        inc !textie_message_pointer_lo  ;
        sep #$20                        ;
        
        rts