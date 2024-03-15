namespace state

    list:
        dw none
        dw init
        dw normal
        dw exit
        
    none: rts
    incsrc "state/init.asm"
    incsrc "state/normal.asm"
    incsrc "state/exit.asm"

namespace off