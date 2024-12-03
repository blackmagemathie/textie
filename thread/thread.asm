namespace thread

incsrc "util.asm"
incsrc "wrap.asm"
incsrc "command.asm"
incsrc "state.asm"

run:
    ; run current thread.
    ; ----------------

    ; wait if thread paused
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