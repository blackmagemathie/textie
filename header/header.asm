namespace header

process:
    ; processes a message header.
    ; ----------------
    ; !textie_header_id          -> id of header type.
    ; !textie_header_pointer (3) -> pointer to header.
    ; ----------------
    ; $00-$02 <- (garbage)
    ; X       <- (garbage)
    ; Y       <- (garbage)
    ; ----------------
    lda !textie_header_pointer_lo : sta $00
    lda !textie_header_pointer_hi : sta $01
    lda !textie_header_pointer_bk : sta $02
    ldy #$00
    lda !textie_header_id
    asl
    tax
    jmp (list,x)

list:
    dw none
    dw default
    
incsrc "item/none.asm"
incsrc "item/default.asm"

namespace off