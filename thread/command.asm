namespace command

macro indexCommand(name,args,chainable,wrapEnd,wrapIgnore)
    dw <name>_main
    db <args>
    db 0+(<chainable>)+(<wrapEnd>*2)+(<wrapIgnore>*4)
    if <wrapIgnore>|<wrapEnd>
        dw $0000
    else
        dw <name>_wrap
    endif
    dw $0000
endmacro

macro insertCommand(name)
    incsrc "command/<name>.asm"
endmacro

list:
    %indexCommand("end",0,0,1,0)                    ; $00
    %indexCommand("newLine",0,1,1,0)                ; $01
    %indexCommand("setCharPalette",1,1,0,1)         ; $02
    %indexCommand("setFont",1,1,0,0)                ; $03
    %indexCommand("setSpacePostchar",1,1,0,0)       ; $04
    %indexCommand("setSpaceRegular",1,1,0,1)        ; $05
    %indexCommand("toggleTranspose",1,1,0,1)        ; $06
    %indexCommand("setTransposeTable",4,1,0,1)      ; $07
    %indexCommand("setBackground",1,1,0,1)          ; $08
    %indexCommand("toggleWrap",1,1,1,0)             ; $09
    %indexCommand("setLeadingSpaceSkip",1,1,0,1)    ; $0a
    %indexCommand("waitFrames",1,0,0,1)             ; $0b
    %indexCommand("waitInput",0,0,0,1)              ; $0c
    
%insertCommand("end")
%insertCommand("newLine")
%insertCommand("setCharPalette")
%insertCommand("setFont")
%insertCommand("setSpacePostchar")
%insertCommand("setSpaceRegular")
%insertCommand("toggleTranspose")
%insertCommand("setTransposeTable")
%insertCommand("setBackground")
%insertCommand("toggleWrap")
%insertCommand("setLeadingSpaceSkip")
%insertCommand("waitFrames")
%insertCommand("waitInput")

namespace off