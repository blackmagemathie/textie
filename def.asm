; tilemap ($800 bytes)
    !textie_tilemap      = $423800
    !textie_tilemap_page = (!textie_tilemap&$03e000)/$2000
    !textie_tilemap_abs  = $6000+(!textie_tilemap&$1fff)

; canvas ($3800 bytes)
    !textie_canvas      = $420000
    !textie_canvas_bmp  = $600000+((!textie_canvas&$0fffff)*4)

; layer
    !textie_layer_backup_gfx = $404000 ; complete backup of layer 3 ($4000 bytes).
    !textie_layer_backup_lm  = $35d0   ; backup of layer 3 image behavior set in lm ($13 bytes).

; thread
    !textie_thread_id     = $3500 ; id.
    !textie_thread_wait   = $350f ; wait timer, in frames.
    !textie_thread_state  = $3510 ; state.
    !textie_thread_option = $3511 ; format : csi-----
                                  ; c = chain commands.
                                  ; s = chain spaces.
                                  ; i = waiting for input.

; message
    !textie_message_pointer_lo   = $3512 ; pointer, lo.
    !textie_message_pointer_hi   = $3513 ;          hi.
    !textie_message_pointer_bk   = $3514 ;          bank.
    !textie_message_pos_gfx_lo   = $3515 ; gfx position, lo.
    !textie_message_pos_gfx_hi   = $3516 ;               hi.
    !textie_message_pos_screen_x = $3517 ; screen position, x.
    !textie_message_pos_screen_y = $3518 ;                  y.
    !textie_message_pos_col      = $3519 ;                  col.

; header
    !textie_header_pointer_lo   = $351b ; pointer, lo.
    !textie_header_pointer_hi   = $351c ;          hi.
    !textie_header_pointer_bk   = $351d ;          bank.
    !textie_header_id           = $351e ; format id.
    
; background
    !textie_background_id  = $351f ; id.

; line
    !textie_line_pos_gfx_lo   = $3520 ; gfx position, lo.
    !textie_line_pos_gfx_hi   = $3521 ;               hi.
    !textie_line_pos_screen_x = $3522 ; screen position, x.
    !textie_line_pos_screen_y = $3523 ;                  y.
    !textie_line_pos_col      = $3524 ;                  col.
    !textie_line_width        = $3525 ; max width, in pixels.
    !textie_line_option       = $3526 ; format : WwSsb---
                                      ; W = word wrap.
                                      ; w = clear if not in a word, set otherwise.
                                      ; S = skip leading spaces.
                                      ; s = clear if in leading spaces, set otherwise.
                                      ; b = disable auto background fill.

; caret
    !textie_caret_pos_fill     = $352b ; next screen x position to trigger background fill.
    !textie_caret_pos_screen_x = $352c ; position, x.
    !textie_caret_pos_col      = $352d ;           col.

; space
    !textie_space_postchar = $352e ; space after characters (in pixels, signed).
    !textie_space_regular  = $352f ;       between words (in pixels, signed).

; font
    !textie_font_id         = $3530 ; id.
    !textie_font_data_bk    = $3531 ; data pointer, bank.
    !textie_font_gfx_lo     = $3532 ; pointer to gfx, lo.
    !textie_font_gfx_hi     = $3533 ;                 hi.
    !textie_font_widths_lo  = $3534 ;            widths, lo.
    !textie_font_widths_hi  = $3535 ;                    hi.
    !textie_font_indices_lo = $3536 ;            gfx indices, lo.
    !textie_font_indices_hi = $3537 ;                         hi.
    !textie_font_height     = $3538 ; height (in 8px tiles, -1).
    
; char
    !textie_char_id        = $3540 ; id.
    !textie_char_option    = $3541 ; format : tc------
                                   ; t = transpose colors.
                                   ; c = process transparency.
    !textie_char_transpose = $3542 ; color transposition table (4 bytes).
    !textie_char_width     = $3546 ; width.
    !textie_char_palette   = $3547 ; palette. ($00-$07)

; sfx
    !textie_sfx_char_id    = $3550 ; -
    !textie_sfx_char_bk    = $3551 ; -
    !textie_sfx_advance_id = $3552 ; -
    !textie_sfx_advance_bk = $3553 ; -
    !textie_sfx_okay_id    = $3554 ; -
    !textie_sfx_okay_bk    = $3555 ; -
    !textie_sfx_cancel_id  = $3556 ; -
    !textie_sfx_cancel_bk  = $3557 ; -
    !textie_sfx_select_id  = $3558 ; -
    !textie_sfx_select_bk  = $3559 ; -
    !textie_sfx_option     = $355f ; format : d--eeeee
                                   ; d = if set, disable all sounds.
                                   ; e = enable sounds, 0 to 4.

; arg
    !textie_arg_pos_gfx_lo      = $35f0 ; gfx position, lo.
    !textie_arg_pos_gfx_hi      = $35f1 ;               hi.
    !textie_arg_pos_col         = $35f2 ; position, col.
    !textie_arg_tilemap_pos_lo  = $35f3 ; tilemap position, lo.
    !textie_arg_tilemap_pos_hi  = $35f4 ;                   hi.
    !textie_arg_tile_priority   = $35f6 ; tile priority (off if zero, on otherwise).
    !textie_arg_tile_counter_lo = $35f7 ; how many tiles to process, lo.
    !textie_arg_tile_counter_hi = $35f8 ;                            hi.
    !textie_arg_quarter         = $35f9 ; which part of layer 3 to upload tilemap to.
    !textie_arg_rows            = $35fa ; -
    !textie_arg_move            = $35fb ; -
    !textie_arg_width           = $35fc ; -