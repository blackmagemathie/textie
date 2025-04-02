namespace state

    list:
        dw none ; 00
        dw init ; 01
        dw normal ; 02
        dw exit ; 03
        dw wait_frames ; 04
        dw wait_input ; 05
        
    incsrc "states/none.asm"
    incsrc "states/init.asm"
    incsrc "states/normal.asm"
    incsrc "states/exit.asm"
    incsrc "states/wait frames.asm"
    incsrc "states/wait input.asm"

namespace off