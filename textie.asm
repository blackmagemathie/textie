%inclib("qutie/def.asm")

incsrc "def.asm"

freedata

    backgrounds:
    incbin "backgrounds.bin"
    
    incsrc "fonts/fonts.asm"

freecode

    namespace nested on
    
    incsrc "layer.asm"
    incsrc "font.asm"
    incsrc "background.asm"
    incsrc "char.asm"
    incsrc "canvas.asm"
    incsrc "tilemap.asm"
    
    incsrc "thread/thread.asm"
    incsrc "header/header.asm"