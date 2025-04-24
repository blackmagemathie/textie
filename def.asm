

; tilemap ($800 bytes)
    !textie_tilemap      = $423800
    !textie_tilemap_page = (!textie_tilemap&$03e000)/$2000
    !textie_tilemap_abs  = $6000+(!textie_tilemap&$1fff)

; canvas ($3800 bytes)
    !textie_canvas      = $420000
    !textie_canvas_bmp  = $600000+((!textie_canvas&$0fffff)*4)

; layer
    !textie_layer_backup_gfx = $424000 ; complete backup of layer 3 ($4000 bytes).
    !textie_layer_backup_lm  = $35d0   ; backup of layer 3 image behavior set in lm ($13 bytes).

; thread
    !textie_thread_id     = $3500 ; id.
    !textie_thread_wait   = $350f ; wait timer, in frames.
    !textie_thread_state  = $3510 ; state.
    !textie_thread_option = $3511 ; format : csi-----
                                  ; c = chain commands.
                                  ; s = chain spaces.
                                  ; i = waiting for input.

; nmi
    !textie_nmi_flags = $3501 ; format:
        !textie_nmi_flag_update_main_screen = $01 ; update main screen using $0d9d

; state ids
    !textie_state_id_none = $00
    !textie_state_id_init = $01
    !textie_state_id_normal = $02
    !textie_state_id_exit = $03
    !textie_state_id_wait_frames = $04
    !textie_state_id_wait_input = $05

; message
    !textie_message_pointer = $3512 ; (3) pointer
    !textie_message_pos_gfx = $3515 ; (2) gfx pos
    !textie_message_pos_screen_x = $3517 ; screen position, x.
    !textie_message_pos_screen_y = $3518 ;                  y.
    !textie_message_pos_col      = $3519 ;                  col.

; header
    !textie_header_pointer = $351b ; (3) pointer
    !textie_header_id      = $351e
    
; background
    !textie_background_id  = $351f ; id.

; line
    !textie_line_pos_gfx      = $3520 ; (2) gfx pos
    !textie_line_pos_screen_x = $3522 ; screen position, x
    !textie_line_pos_screen_y = $3523 ;                  y
    !textie_line_pos_col      = $3524 ;                  col
    !textie_line_width        = $3525 ; max width, in px
    !textie_line_option       = $3526 ; format:
        !textie_line_flag_wrap      = $80 ; enable word wrap
        !textie_line_flag_in_word   = $40 ; set if in word / clear if in space
        !textie_line_flag_lead_skip = $20 ; skip leading spaces
        !textie_line_flag_in_lead   = $10 ; set if in leading spaces
        !textie_line_flag_autofill  = $08 ; enable auto background fill

; box
    !textie_box_id = $352a ; (1) id

; caret
    !textie_caret_pos_fill     = $352b ; next screen x position to trigger background fill.
    !textie_caret_pos_screen_x = $352c ; position, x.
    !textie_caret_pos_col      = $352d ;           col.

; space
    !textie_space_postchar = $352e ; space after characters (in pixels, signed).
    !textie_space_regular  = $352f ;       between words (in pixels, signed).

; font
    !textie_font_id         = $3530 ; id.
    !textie_font_bk         = $3531 ; pointer bank
    !textie_font_gfx        = $3532 ; (2) pointer to gfx
    !textie_font_widths     = $3534 ; (2)            widths
    !textie_font_indices    = $3536 ; (2)            gfx indices
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
    !textie_arg_pos_gfx = $35f0 ; (2) gfx pos
    !textie_arg_pos_col         = $35f2 ; position, col.
    !textie_arg_tilemap_pos  = $35f3 ; (2) tilemap pos
    !textie_arg_tile_priority   = $35f6 ; tile priority (off if zero, on otherwise).
    !textie_arg_tile_counter = $35f7 ; (2) how many tiles to process
    !textie_arg_quarter         = $35f9 ; which part of layer 3 to upload tilemap to.
    !textie_arg_rows            = $35fa ; -
    !textie_arg_move            = $35fb ; -
    !textie_arg_width           = $35fc ; -
    !textie_command_abs = $35fd ; (2) absolute addr of command to jump to