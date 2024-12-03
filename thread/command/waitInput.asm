namespace waitInput

; halts thread until A or B is pressed.
; ----------------

main:
    lda #$20
    tsb !textie_thread_option
    rts

namespace off