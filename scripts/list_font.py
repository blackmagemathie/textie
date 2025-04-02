import json
from os import sep
from util import error, testfile, getlines, orderlines

def list_font():

    fp_list = ".."+sep+"list"+sep+"fonts.txt"
    fp_dir_fonts = ".."+sep+"fonts"
    fp_dir_temp = ".."+sep+"temp"
    fn_gfx = "gfx.bin"
    fn_index = "indices.bin"
    fn_width = "widths.bin"
    fn_props = "properties.json"
    fp_temp_index = ".."+sep+"temp"+sep+"font_index.asm"
    fp_temp_data  = ".."+sep+"temp"+sep+"font_data.asm"
    deps = []

    # convert list
    testfile(fp_list)
    with open(fp_list,"r",encoding="utf-8") as fio_list:
        lines = getlines(fio_list)
    fonts = orderlines(lines,0x100)
        
    # produce files
    counter = 0
    with open(fp_temp_index,"w") as fio_temp_index, open(fp_temp_data,"w") as fio_temp_data:

        temp_index = (
            "freedata\n"
            "font_data_index:\n"
            "fillbyte $00\n"
        )
        fio_temp_index.write(temp_index)

        for font in fonts:

            # empty?
            if not font:
                fio_temp_index.write("fill 8\n")
                continue

            # get props
            font_dir_raw = (fp_dir_fonts+sep+font["arg"]+sep)
            font_dir = font_dir_raw.replace(sep,"/")
            with open(font_dir_raw+fn_props,"r") as fio_props:
                props = json.load(fio_props)
            deps.append(font_dir_raw+fn_props)

            # data
            label = "font_data_"+str(font["id"])
            pw = font_dir+fn_width
            pg = font_dir+fn_gfx
            pi = font_dir+fn_index
            temp_data = (
                "freedata\n"
                "{0}:\n"
                ".w: incbin \"{1}\"\n"
                ".g: incbin \"{2}\"\n"
                ".i: incbin \"{3}\"\n"
            ).format(label,pw,pg,pi)
            fio_temp_data.write(temp_data)
            deps.append(font_dir_raw+fn_width)
            deps.append(font_dir_raw+fn_gfx)
            deps.append(font_dir_raw+fn_index)
                
            # index
            temp_index = (
                "db {0}>>16\n"
                "dw {0}_w\n"
                "dw {0}_g\n"
                "dw {0}_i\n"
                "db {1}\n"
            ).format(label,props["height"]-1)
            fio_temp_index.write(temp_index)

            counter += 1
    
    print("prep'd "+str(counter)+" fonts successfully.")
    return deps