%inclib("qutie/def.asm")

incsrc "def.asm"

freedata
    
    background_data: incbin "background/data.bin"
    incsrc "temp/font_index.asm"
    incsrc "temp/font_data.asm"
    
freecode
    
    namespace nested on
    
    incsrc "code/tilemap.asm"
    incsrc "code/font.asm"
    incsrc "code/layer.asm"
    incsrc "code/char.asm"
    incsrc "code/canvas.asm"
    
    incsrc "background/background.asm"
    incsrc "thread/thread.asm"
    incsrc "header/header.asm"