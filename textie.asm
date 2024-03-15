%inclib("qutie/def.asm")

incsrc "def.asm"

freedata
    
    background_data: incbin "background/data.bin"
    incsrc "font/list.asm"
    
freecode
    
    namespace nested on
    
    incsrc "layer.asm"
    incsrc "char.asm"
    incsrc "canvas.asm"
    incsrc "tilemap.asm"
    
    incsrc "font/font.asm"
    incsrc "background/background.asm"
    incsrc "thread/thread.asm"
    incsrc "header/header.asm"