namespace newLine

; start a new line.

main:
    stz $2250                           ; set gfx pos.
    lda !textie_caret_pos_fill          ;
    sec                                 ;
    sbc !textie_line_pos_screen_x       ;
    sta $2251                           ;
    stz $2252                           ;
    lda !textie_font_height             ;
    inc                                 ;
    sta $2253                           ;
    stz $2254                           ;
    rep #$20                            ;
    nop                                 ;
    lda $2306                           ;
    clc                                 ;
    adc !textie_line_pos_gfx_lo         ;
    sta !textie_line_pos_gfx_lo         ;
    sep #$20                            ;
    lda !textie_message_pos_screen_x    ; set screen and col pos.
    sta !textie_line_pos_screen_x       ;
    sta !textie_caret_pos_screen_x      ;
    sta !textie_caret_pos_fill          ;
    lda !textie_line_pos_screen_y       ;
    sec                                 ;
    adc !textie_font_height             ;
    sta !textie_line_pos_screen_y       ;
    lda !textie_message_pos_col         ;
    sta !textie_line_pos_col            ;
    sta !textie_caret_pos_col           ;
    lda #$40                            ; clear word flag.
    trb !textie_line_option
    rts

namespace off