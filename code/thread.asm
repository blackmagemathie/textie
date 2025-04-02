namespace thread

run:

    phb
    phk
    plb
    lda.w !textie_thread_state
    asl
    tax
    jsr (state_list,x)
    plb
    
    rtl

namespace off