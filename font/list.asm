namespace font_data

    ; indexes a font.
    ; ----------------
    ; name   <- font/folder name.
    ; height <- font height in 8px tiles, minus 1.
    ; ----------------
    macro indexFont(name,height)
        db <name>>>16
        dw <name>_widths
        dw <name>_gfx
        dw <name>_indices
        db <height>
    endmacro
    
    ; inserts font data.
    ; ----------------
    ; name <- font/folder name.
    ; ----------------
    macro insertFont(name)
        freedata
        <name>:
            .widths:  incbin "item/<name>/widths.bin"
            .gfx:     incbin "item/<name>/gfx.bin"
            .indices: incbin "item/<name>/indices.bin"
    endmacro

    ; INDEX+INSERT FONTS BELOW
    
    index:
        %indexFont("fontie",0)
    
    %insertFont("fontie")
        
namespace off