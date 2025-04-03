%inclib("qutie/def.asm")

incsrc "def.asm"

freedata
    
    background_data: incbin "backgrounds/data.bin"
    incsrc "temp/box_index.asm"
    incsrc "temp/command_index.asm"
    incsrc "temp/font_index.asm"
    incsrc "temp/font_data.asm"
    
freecode
    
    namespace nested on

    incsrc "code/font.asm"
    incsrc "code/header.asm"
    incsrc "code/tilemap.asm"
    incsrc "code/layer.asm"
    incsrc "code/char.asm"
    incsrc "code/canvas.asm"
    incsrc "code/background.asm"
    incsrc "code/state.asm"
    incsrc "code/wrap.asm"
    incsrc "code/util.asm"
    incsrc "code/thread.asm"
    
    incsrc "temp/box_code.asm"
    incsrc "temp/command_code.asm"