namespace util

moveCaret:
    ; moves caret within line.
    ; ----------------
    ; !textie_arg_move <- horizontal movement (in px, signed).
    ; ----------------
    lda !textie_caret_pos_screen_x
    asl #3
    ora !textie_caret_pos_col
    clc
    adc !textie_arg_move
    sta !textie_caret_pos_col
    lsr #3
    sta !textie_caret_pos_screen_x
    lda #$f8
    trb !textie_caret_pos_col
    rts

namespace off