namespace header

run:
    ; runs message header.
    ; ----------------
    ; !textie_header_id (1)      -> id
    ; !textie_header_pointer (3) -> pointer
    ; ----------------
    ; $00 (3) <- (garbage)
    ; X       <- (garbage)
    ; Y       <- (garbage)
    ; ----------------
    lda !textie_header_pointer   : sta $00
    lda !textie_header_pointer+1 : sta $01
    lda !textie_header_pointer+2 : sta $02
    lda !textie_header_id
    asl
    tax
    jmp (list,x)

list:
    dw none
    dw classic
    dw default
    
incsrc "item/none.asm"
incsrc "item/classic.asm"
incsrc "item/default.asm"

namespace off