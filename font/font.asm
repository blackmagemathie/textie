namespace font

load:
    ; grabs font pointers and properties.
    ; ----------------
    ; font_id -> font to load.
    ; ----------------
    phx                 ; preserve x.
    rep #$30            ; get index to font metadata.
    lda !textie_font_id ;
    and #$00ff          ;
    asl #3              ;
    tax                 ;
    lda.l font_data_index+$01,x ; get pointer to widths.
    sta !textie_font_widths_lo  ;
    lda.l font_data_index+$03,x ; get pointer to gfx.
    sta !textie_font_gfx_lo     ;
    lda.l font_data_index+$05,x ; get pointer to gfx indices.
    sta !textie_font_indices_lo ;
    sep #$20                    ;
    lda.l font_data_index+$00,x ; get data pointer bank.
    sta !textie_font_data_bk    ;
    lda.l font_data_index+$07,x ; get height.
    sta !textie_font_height     ;
    sep #$10    ;
    plx         ; restore x.
    rts
    
namespace off
