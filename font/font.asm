namespace font

load:
    ; grabs font pointers and properties.
    ; ----------------
    ; font_id (1) -> font to load
    ; ----------------
    phx

    ; get font metadata index
    rep #$30
    lda !textie_font_id
    and #$00ff
    asl #3
    tax

    ; get pointers
    lda.l font_data_index+$01,x
    sta !textie_font_widths
    lda.l font_data_index+$03,x
    sta !textie_font_gfx
    lda.l font_data_index+$05,x
    sta !textie_font_indices
    sep #$20
    lda.l font_data_index+$00,x
    sta !textie_font_bk

    ; get height
    lda.l font_data_index+$07,x
    sta !textie_font_height
    sep #$10

    plx
    rts

namespace off
