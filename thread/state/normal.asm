normal:
    ; executes thread normally. (wip)
    ; ----------------
    lda #$80                ; setup bitmap mode
    sta $223f               ;
    .readChar:
    rep #$20                ; setup pointer
    lda !messagePointerLo   ;
    sta $00                 ;
    sep #$20                ;
    lda !messagePointerBk   ;
    sta $02                 ;
    lda [$00]               ; command, space or char?
    beq .cmd                ;
    cmp #$ff                ;
    beq .space              ;
    bra .char               ;
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
        adc !messagePointerLo           ;
        sta !messagePointerLo           ;
        sep #$20                        ;
        lda !threadOptions              ; if chaining enabled,
        bpl +                           ;
        lda.w thread_command_list+3,x   ; and command is chainable,
        bit #$01                        ;
        bne .readChar                   ; keep processing
        +                               ;
        rts
    ; ----------------
    .space:
        lda !lineOptions                ; skip leading spaces?
        bit #$20                        ;
        beq +                           ;
        bit #$10                        ; if yes, and in leading spaces,
        beq ++                          ; skip
        +                               ;
            
        lda !spaceRegular               ; move caret
        sta !argMove                    ;
        jsr thread_util_moveCaret       ;
            
        lda !lineOptions                ; words wrap enabled?
        bpl +                           ;
        lda !linePosScreenX             ; get line end pos
        asl #3                          ;
        ora !linePosCol                 ;
        clc                             ;
        adc !lineWidth                  ;
        sta $00                         ;
        lda !caretPosScreenX            ; get caret pos
        asl #3                          ;
        ora !caretPosCol                ;
        cmp $00                         ; if too far,
        bcc +                           ;
        jsr thread_command_newLine_main ; start new line
        +                               ;
        ++  
        rep #$20                        ; move pointer
        inc !messagePointerLo           ;
        sep #$20                        ;
        lda #$40                        ; clear word flag
        trb !lineOptions                ;
        lda !threadOptions              ; if chaining enabled,
        and #$40                        ;
        beq +                           ;
        jmp .readChar                   ; keep processing
        +                               ;
        rts
    ; ----------------
    .char:
        sta !charId             ; save char id
        jsr char_getWidth       ; get width
        bne +                   ; if zero,
        rep #$20                ; move pointer,
        inc !messagePointerLo   ;
        sep #$20                ;
        rts                     ; and return
        +                       ;
        
        lda !lineOptions        ; word wrap enabled?
        bpl +                   ; 
        bit #$40                ; word flag clear?
        bne +                   ;
        
        lda !caretPosScreenX        ; get caret pos
        asl #3                      ;
        ora !caretPosCol            ;
        sta $03                     ;
        lda !linePosScreenX         ; get line end pos
        asl #3                      ;
        ora !linePosCol             ;
        clc                         ;
        adc !lineWidth              ;
        sec                         ; get max width
        sbc $03                     ;
        sta !argWidth               ;
        rep #$20                    ; get pointer
        lda !messagePointerLo       ;
        sta $00                     ;
        sep #$20                    ;
        lda !messagePointerBk       ;
        sta $02                     ;
        jsr thread_wrap_testWord    ; test word
        bcc +
        jsr thread_command_newLine_main
        +
        
        lda !caretPosScreenX    ; move caret in theory
        asl #3                  ;
        ora !caretPosCol        ;
        clc                     ;
        adc !charWidth          ;
        sta $01                 ;
        lsr #3                  ;
        sta $00                 ;
        lda #$f8                ;
        trb $01                 ;
        lda $00                 ; before next fill?
        cmp !caretPosNextFill   ;
        bcc ..noFill            ;
        lda $01                 ; if no, get number of tiles to fill
        beq +                   ;
        lda #$01                ;
        +                       ;
        clc                     ;
        adc $00                 ;
        sec                     ;
        sbc !caretPosNextFill   ;
        beq ..noFill            ; if zero, don't fill
        pha                     ; preserve number,
        lda !lineOptions
        and #$08
        bne +
        stz $2250               ; get exact tile count,
        sta $2251               ;
        stz $2252               ;
        lda !fontHeight         ;
        inc                     ;
        sta $2253               ;
        stz $2254               ;
        nop #3                  ;
        lda $2306               ;
        sta !tileCounterLo      ;
        stz $2250               ; get gfx pos,
        lda !caretPosNextFill   ;
        sec                     ;
        sbc !linePosScreenX     ;
        sta $2251               ;
        stz $2252               ;
        lda !fontHeight         ;
        inc                     ;
        sta $2253               ;
        stz $2254               ;
        rep #$20                ;
        lda !linePosGfxLo       ;
        clc                     ;
        adc $2306               ;
        sta !argPosGfxLo        ;
        sep #$20                ;
        jsr background_draw     ; draw bg,
        +
        pla                     ; and move next fill trigger
        clc                     ;
        adc !caretPosNextFill   ;
        sta !caretPosNextFill   ;
        ..noFill:

        stz $2250               ; draw char
        lda !caretPosScreenX    ;
        sec                     ;
        sbc !linePosScreenX     ;
        sta $2251               ;
        stz $2252               ;
        lda !fontHeight         ;
        inc                     ;
        sta $2253               ;
        stz $2254               ;
        rep #$20                ;
        lda !linePosGfxLo       ;
        clc                     ;
        adc $2306               ;
        sta !argPosGfxLo        ;
        sep #$20                ;
        lda !caretPosCol        ;
        sta !argPosCol          ;
        jsr char_draw           ;
        
        lda !caretPosCol        ; upload gfx
        and #$07                ;
        clc                     ;
        adc !charWidth          ;
        pha                     ;
        lsr #3                  ;
        sta $00                 ;
        pla                     ;
        and #$07                ;
        beq +                   ;
        inc $00                 ;
        +                       ;
        stz $2250               ;
        lda $00                 ;
        sta $2251               ;
        stz $2252               ;
        lda !fontHeight         ;
        inc                     ;
        sta $2253               ;
        stz $2254               ;
        rep #$20                ;
        nop                     ;
        lda $2306               ;
        sta !tileCounterLo      ;
        sep #$20                ;
        jsr canvas_upload       ;

        rep #$20                ; write to tilemap
        lda !linePosScreenY-1   ;
        and #$ff00              ;
        lsr #3                  ;
        sep #$20                ;
        ora !caretPosScreenX    ;
        rep #$20                ;
        sta !mapPosLo           ;
        sep #$20                ;
        lda $00                 ;
        sta !tileCounterLo      ;
        sta !tilePriority       ;
        jsr tilemap_layText     ;

        lda #$03                ; upload tilemap
        sta !layerQuarter       ;
        lda !fontHeight         ;
        inc                     ;
        sta !argRows            ;
        jsr tilemap_upload      ;

        lda !charWidth              ; move caret
        clc                         ;
        adc !spacePostchar          ;
        sta !argMove                ;
        jsr thread_util_moveCaret   ;
        lda #$50                    ; set word flag, and out-of-leading-spaces flag
        tsb !lineOptions            ;
        rep #$20                    ; move pointer
        inc !messagePointerLo       ;
        sep #$20                    ;
        
        rts