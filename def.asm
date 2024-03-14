!tilemap                = $413800   ; layer 3 tilemap
!tilemapPage            = (!tilemap&$01e000)/$2000
!tilemapAbsolute        = $6000+(!tilemap&$1fff)
; ----------------
!canvas                 = $410000   ; canvas to draw text on ($3800 bytes).
!canvasVirtual          = $600000+((!canvas&$0fffff)*4)
; ----------------
!layerBackupGfx         = $404000   ; complete backup of layer 3 ($4000 bytes).
!layerBackupBehavior    = $35d0     ; backup of layer 3 image behavior set in lm ($13 bytes).
; ----------------
!threadData             = $41a000   ; thread data (???×??? bytes).
!threadSlots            = $01       ; how many threads are supported.
; ----------------

!threadId               = $3500 ; thread id.
!threadIndex            = $3501 ; 

!threadWait             = $350f ; thread pause time, in frames.
!threadState            = $3510 ;        state.
!threadOptions          = $3511 ;        options. format : csbp----
                                ; c = chain commands.
                                ; s = chain spaces.
                                ; b = use message box.
                                ; p = pause game while thread is active.
!messagePointerLo       = $3512 ; message pointer, lo.
!messagePointerHi       = $3513 ;                  hi.
!messagePointerBk       = $3514 ;                  bank.
!messagePosGfxLo        = $3515 ; message gfx position, lo.
!messagePosGfxHi        = $3516 ;                       hi.
!messagePosScreenX      = $3517 ; message screen position, x.
!messagePosScreenY      = $3518 ;                          y.
!messagePosCol          = $3519 ;                          col.

!backgroundId           = $351f ; background id.

!linePosGfxLo           = $3520 ; line gfx position, lo.
!linePosGfxHi           = $3521 ;                    hi.
!linePosScreenX         = $3522 ; line screen position, x.
!linePosScreenY         = $3523 ;                       y.
!linePosCol             = $3524 ;                       col.
!lineWidth              = $3525 ; max width of line, in pixels.
!lineOptions            = $3526 ; line options. format : WwSsb---
                                ; W = enable word wrap.
                                ; w = clear if not in a word, set otherwise.
                                ; S = skip leading spaces
                                ; s = clear if in leading spaces, set otherwise.
                                ; b = disable automatic background drawing.
!caretPosNextFill       = $352b ; next caret position to trigger background fill.
!caretPosScreenX        = $352c ; caret position, x.
!caretPosCol            = $352d ;                 col.
!spacePostchar          = $352e ; space after characters.
!spaceRegular           = $352f ;       between words.

!fontId                 = $3530 ; font id.
!fontDataBk             = $3531 ;      data bank.
!fontGfxLo              = $3532 ;      gfx source, lo.
!fontGfxHi              = $3533 ;                  hi.
!fontWidthsLo           = $3534 ;      width table source, lo.
!fontWidthsHi           = $3535 ;                          hi.
!fontIndicesLo          = $3536 ;      gfx indices source, lo.
!fontIndicesHi          = $3537 ;                          hi.
!fontHeight             = $3538 ;      height. ($00-$03 -> 8px-32px)
    
!charId                 = $3540 ; char id.
!charOptions            = $3541 ;      options. format : tc------
                                ; t = transpose colors.
                                ; c = process transparency.
!charTranspose0         = $3542 ; transposition table for char colors (consecutive bytes).
!charTranspose1         = $3543 ;
!charTranspose2         = $3544 ;
!charTranspose3         = $3545 ;
!charWidth              = $3546 ; char width.
!charPalette            = $3547 ;      palette. ($00-$07)

!sfxIdChar              = $3550 ; ???
!sfxBkChar              = $3551 ; ???
!sfxIdAdvance           = $3552 ; ???
!sfxBkAdvance           = $3553 ; ???
!sfxIdOkay              = $3554 ; ???
!sfxBkOkay              = $3555 ; ???
!sfxIdCancel            = $3556 ; ???
!sfxBkCancel            = $3557 ; ???
!sfxIdSelect            = $3558 ; ???
!sfxBkSelect            = $3559 ; ???
!soundOptions           = $355f ; sound options. format : d--eeeee
                                ; d = if set, disable all sounds.
                                ; e = enable sounds, 0 to 4.
    
!argPosGfxLo            = $35f0 ; gfx position, lo.
!argPosGfxHi            = $35f1 ;               hi.
!argPosCol              = $35f2 ; position, col.

!mapPosLo               = $35f3 ; tilemap position, lo.
!mapPosHi               = $35f4 ;                   hi.
!tilePalette            = $35f5 ; tile palette ($00-$07)
!tilePriority           = $35f6 ; tile priority (0 or non-0)
!tileCounterLo          = $35f7 ; how many tiles to process, lo.
!tileCounterHi          = $35f8 ;                            hi.
!layerQuarter           = $35f9 ; which part of layer 3 to upload tilemap to.
!argRows                = $35fa ; ???
!argMove                = $35fb ; ???
!argWidth               = $35fc ; ???