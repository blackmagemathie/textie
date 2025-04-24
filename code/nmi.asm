namespace "nmi"

run:
    ; run textie nmi functions
    ; ----------------

    ; update main screen?
    lda.w !textie_nmi_flags
    bit.b #!textie_nmi_flag_update_main_screen
    beq +
        lda $0d9d|!addr
        sta $212c
        sta $212e
    +

    ; clear all flags
    stz.w !textie_nmi_flags

    rtl

namespace off