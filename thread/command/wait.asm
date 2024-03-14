namespace wait

; halts thread for a specific amount of frames.

main:
    lda [$00],y
    dec
    sta !threadWait
    rts

namespace off