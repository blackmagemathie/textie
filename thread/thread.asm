namespace thread

incsrc "util.asm"
incsrc "header.asm"
incsrc "wrap.asm"
incsrc "command.asm"
incsrc "state.asm"

process:
    ; processes current thread.
    ; ----------------
    lda !threadWait     ; wait?
    beq +               ; if yes,
    dec                 ; decrease timer,
    sta !threadWait     ;
    rtl                 ; and return.
    +                   ;
    phb                 ; adjust bank.
    phk                 ;
    plb                 ;
    lda !threadState    ; get state,
    asl                 ; as a pointer,
    tax                 ; into x,
    jsr (state_list,x)  ; and process.
    plb                 ; restore bank.
    rtl                 ; end.

namespace off