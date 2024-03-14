namespace fonts

    ; indexes a font.
    ; ----------------
    ; name   <- font/folder name.
    ; height <- font height in 8px tiles, minus 1.
    ; ----------------
    macro indexFont(name,height)
        db data_<name>>>16
        dw data_<name>_widths
        dw data_<name>_gfx
        dw data_<name>_indices
        db <height>
    endmacro
    
    ; inserts font data.
    ; ----------------
    ; name <- font/folder name.
    ; ----------------
    macro insertFont(name)
        freedata
        .<name>:
            ..widths:  incbin "<name>/widths.bin"
            ..gfx:     incbin "<name>/gfx.bin"
            ..indices: incbin "<name>/indices.bin"
    endmacro

    ; INDEX+INSERT FONTS BELOW
    
    index:
        %indexFont("fontie",0)
    
    data:
        %insertFont("fontie")
        
namespace off