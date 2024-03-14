namespace font

load:
    ; grabs a font pointers and properties.
    ; ----------------
    ; font_id -> font to load.
    ; ----------------
    phx                                                     ; preserve x.
    rep #$30                                                ; index font metadata
    lda !textie_font_id                                     ;
    and #$00ff                                              ;
    asl #3                                                  ;
    tax                                                     ;
    lda.l fonts_index+$01,x : sta !textie_font_widths_lo    ; widths
    lda.l fonts_index+$03,x : sta !textie_font_gfx_lo       ; gfx
    lda.l fonts_index+$05,x : sta !textie_font_indices_lo   ; indices
    sep #$20                                                ;
    lda.l fonts_index+$00,x : sta !textie_font_data_bk      ; data bank
    lda.l fonts_index+$07,x : sta !textie_font_height       ; height
    sep #$10                                                ; restore x
    plx                                                     ;
    rts                                                     ; end
    
namespace off
