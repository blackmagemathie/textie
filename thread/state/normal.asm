normal:
    ; executes thread normally.
    ; ----------------
    lda #$80    ; set bitmap mode.
    sta $223f   ;
    .readChar:
    rep #$20                        ; get message pointer.
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
    ; ----
    .cmd:
        ldy #$01                        ; get command index into x.
        lda [$00],y                     ;
        asl #3                          ;
        tax                             ;
        iny                             ; execute command (main routine).
        phx                             ;
        jsr (thread_command_list,x)     ;
        plx                             ;
        lda #$00                        ; move message pointer.
        xba                             ;
        lda.w thread_command_list+2,x   ;
        inc #2                          ;
        rep #$20                        ;
        clc                             ;
        adc !textie_message_pointer_lo  ;
        sta !textie_message_pointer_lo  ;
        sep #$20                        ;
        lda !textie_thread_option       ; command chaining enabled?
        bpl +                           ; if yes,
        lda.w thread_command_list+3,x   ; command chainable?
        bit #$01                        ; if yes,
        bne .readChar                   ; keep going.
        +
        rts
    ; ----
    .space:
        lda !textie_line_option         ; skip leading spaces?
        bit #$20                        ; if yes, 
        beq +                           ;
        bit #$10                        ; in leading spaces?
        beq ++                          ; if yes, skip caret movement.
        +                               ;
        lda !textie_space_regular       ; move caret.
        sta !textie_arg_move            ;
        jsr thread_util_moveCaret       ;
        lda !textie_line_option         ; word wrap enabled?
        bpl +                           ; if yes,
        lda !textie_line_pos_screen_x   ; get line end pos,
        asl #3                          ;
        ora !textie_line_pos_col        ;
        clc                             ;
        adc !textie_line_width          ;
        sta $00                         ;
        lda !textie_caret_pos_screen_x  ; get caret pos,
        asl #3                          ;
        ora !textie_caret_pos_col       ;
        cmp $00                         ; and check if exceeded.
        bcc +                           ; if yes,
        jsr thread_command_newLine_main ; start new line.
        +                               ;
        ++  
        rep #$20                        ; move message pointer.
        inc !textie_message_pointer_lo  ;
        sep #$20                        ;
        lda #$40                        ; clear word flag.
        trb !textie_line_option         ;
        lda !textie_thread_option       ; space chaining enabled?
        and #$40                        ;
        beq +                           ; if yes,
        jmp .readChar                   ; keep going.
        +
        rts
    ; ----
    .char:
        ; get and test char width.
        sta !textie_char_id             ; set char id.
        jsr char_getWidth               ; get char width.
        bne +                           ; zero? if yes,
        rep #$20                        ; move message pointer,
        inc !textie_message_pointer_lo  ;
        sep #$20                        ;
        rts                             ; and return early.
        +                               ;
        
        ; process word wrap.
        lda !textie_line_option         ; word wrap enabled?
        bpl +                           ; if yes,
        bit #$40                        ; word flag clear?
        bne +                           ; if yes,
        lda !textie_caret_pos_screen_x  ; get caret pos,
        asl #3                          ;
        ora !textie_caret_pos_col       ;
        sta $03                         ;
        lda !textie_line_pos_screen_x   ; get line end pos,
        asl #3                          ;
        ora !textie_line_pos_col        ;
        clc                             ;
        adc !textie_line_width          ;
        sec                             ; get max width,
        sbc $03                         ;
        sta !textie_arg_width           ;
        rep #$20                        ; get message pointer,
        lda !textie_message_pointer_lo  ;
        sta $00                         ;
        sep #$20                        ;
        lda !textie_message_pointer_bk  ;
        sta $02                         ;
        jsr thread_wrap_testWord        ; and test word.
        bcc +                           ; fits? if no,
        jsr thread_command_newLine_main ; start new line.
        +
        
        ; process auto background fill.
        lda !textie_caret_pos_screen_x  ; simulate caret movement.
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
        bcc ++                          ; if no,
        lda $01                         ; count tiles to fill.
        beq +                           ;
        lda #$01                        ;
        +                               ;
        clc                             ;
        adc $00                         ;
        sec                             ;
        sbc !textie_caret_pos_fill      ;
        beq ++                          ; if zero, don't fill.
        pha                             ; else, preserve number,
        lda !textie_line_option         ; auto background drawing enabled?
        and #$08                        ;
        bne +                           ; if yes,
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
        jsr background_draw             ; and fill background.
        +                               ;
        pla                             ; move next fill trigger.
        clc                             ;
        adc !textie_caret_pos_fill      ;
        sta !textie_caret_pos_fill      ;
        ++

        ; draw char.
        stz $2250                       ; get canvas pos,
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
        jsr char_draw                   ; and draw char.
        
        ; upload to canvas.
        lda !textie_caret_pos_col       ; get tile count,
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
        jsr canvas_upload               ; and upload canvas to vram.
        
        ; lay text into tilemap.
        rep #$20                        ; get tilemap pos,
        lda !textie_line_pos_screen_y-1 ;
        and #$ff00                      ;
        lsr #3                          ;
        sep #$20                        ;
        ora !textie_caret_pos_screen_x  ;
        rep #$20                        ;
        sta !textie_arg_tilemap_pos_lo  ;
        sep #$20                        ;
        lda $00                         ;
        sta !textie_arg_tile_counter_lo ; get tile count,
        sta !textie_arg_tile_priority   ; set priority,
        jsr tilemap_layText             ; and lay text into tilemap.
        
        ; upload tilemap.
        lda #$03                ; set quarter to upload to,
        sta !textie_arg_quarter ;
        lda !textie_font_height ; get row count,
        inc                     ;
        sta !textie_arg_rows    ;
        jsr tilemap_upload      ; and upload tilemap to vram.
        
        ; move caret.
        lda !textie_char_width          ; get char width,
        clc                             ; add postchar space,
        adc !textie_space_postchar      ;
        sta !textie_arg_move            ; set caret movement,
        jsr thread_util_moveCaret       ; and move caret.
        
        ; finish
        lda #$50                        ; set word flag, and leading space flag.
        tsb !textie_line_option         ;
        rep #$20                        ; move message pointer.
        inc !textie_message_pointer_lo  ;
        sep #$20                        ;
        
        rts