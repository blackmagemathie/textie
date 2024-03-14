namespace wait

; halts thread for a specific amount of time.
; ----------------
; arg. 0 <- time to wait (in frames).

main:
    lda [$00],y
    dec
    sta !textie_thread_wait
    rts

namespace off