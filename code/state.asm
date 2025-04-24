namespace state

    list:
        dw none ; 00
        dw init ; 01
        dw normal ; 02
        dw exit ; 03
        dw wait_frames ; 04
        dw wait_input ; 05
        dw run_message ; 06
        dw 0 ; 07
        dw box_draw_init ; 08
        dw box_draw_main ; 09
        dw box_clear_init ; 0a
        dw box_clear_main ; 0b
        dw box_erase_init ; 0c
        dw box_erase_main ; 0d
        
    incsrc "states/none.asm"
    incsrc "states/init.asm"
    incsrc "states/normal.asm"
    incsrc "states/exit.asm"
    incsrc "states/wait frames.asm"
    incsrc "states/wait input.asm"
    incsrc "states/run message.asm"
    incsrc "states/box draw.asm"
    incsrc "states/box clear.asm"
    incsrc "states/box erase.asm"

namespace off