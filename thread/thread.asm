namespace thread

incsrc "util.asm"
incsrc "wrap.asm"
incsrc "command.asm"
incsrc "state.asm"

run:
    ; run current thread.
    ; ----------------

    ; waiting for input?
    lda !textie_thread_option
    and #$20
    beq ++
    lda $16
    ora $18
    bmi +
    rtl
    +
    lda #$20
    trb !textie_thread_option
    ++

    ; waiting for frames?
    lda !textie_thread_wait
    beq +
    dec
    sta !textie_thread_wait
    rtl
    +

    phb
    phk
    plb
    lda !textie_thread_state
    asl
    tax
    jsr (state_list,x)
    plb
    
    rtl

namespace off