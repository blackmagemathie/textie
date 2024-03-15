namespace thread

incsrc "util.asm"
incsrc "wrap.asm"
incsrc "command.asm"
incsrc "state.asm"

process:
    ; processes current thread.
    ; ----------------
    lda !textie_thread_wait     ; wait?
    beq +                       ; if yes,
    dec                         ; decrease timer,
    sta !textie_thread_wait     ;
    rtl                         ; and return.
    +                           ;
    phb                         ; adjust bank.
    phk                         ;
    plb                         ;
    lda !textie_thread_state    ; get state,
    asl                         ; as a pointer,
    tax                         ; into x,
    jsr (state_list,x)          ; and process.
    plb                         ; restore bank.
    rtl                         ; end.

namespace off