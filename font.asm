namespace font

load:
    ; gets a font's pointers and properties.
    ; ----------------
    ; fontId -> font to load.
    ; ----------------
    phx                                             ; preserve x
    rep #$30                                        ; index font metadata
    lda !fontId                                     ;
    and #$00ff                                      ;
    asl #3                                          ;
    tax                                             ;
    lda.l fonts_index+$01,x : sta !fontWidthsLo     ; widths
    lda.l fonts_index+$03,x : sta !fontGfxLo        ; gfx
    lda.l fonts_index+$05,x : sta !fontIndicesLo    ; indices
    sep #$20                                        ;
    lda.l fonts_index+$00,x : sta !fontDataBk       ; data bank
    lda.l fonts_index+$07,x : sta !fontHeight       ; height
    sep #$10                                        ; restore x
    plx                                             ;
    rts                                             ; end
    
namespace off
