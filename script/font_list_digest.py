import os
import json
from os import sep
from os.path import isfile
import re
from util import error

def main():

    fp_list = ".."+sep+"list"+sep+list_fonts.txt"
    fp_dir_fonts = ".."+sep+"fonts"
    fp_dir_temp = ".."+sep+"temp"
    fn_gfx = "gfx.bin"
    fn_index = "indices.bin"
    fn_width = "widths.bin"
    fn_props = "properties.json"
    fn_temp_font_index = "font_index.asm"
    fn_temp_font_data = "font_data.asm"

    # file exists?
    if not isfile(fp_list):
        error("\"font_list.txt\" not found")

    # get lines
    lines = []
    line_format = r"[0-9a-fA-F]{2}\s+.+"
    with open(fp_list,"r",encoding="utf-8") as fio_list:
        for line_num,line in enumerate(fio_list):
            line_clean = line.strip()
            if line_clean:
                if not re.fullmatch(line_format,line_clean):
                    error("invalid syntax @ line "+str(line_num))
                lines.append(line_clean)
    if len(lines)<1:
        error("empty font list")

    # lines to fonts
    fonts = [None for i in range(0,0x100)]
    for line in lines:
        font_id_raw = line[0:2].lower()
        font_id = int(font_id_raw,16)
        if fonts[font_id]:
            error("font id $"+font_id_raw+" has duplicate(s)")
        font_dir = line[2:].strip()
        font_dir_full = fp_dir_fonts+sep+font_dir
        fonts[font_id] = {
            "id":font_id,
            "dir":font_dir_full
        }
    cull = 0xff
    while cull>0:
        if fonts[cull]:
            cull += 1
            break
        cull -= 1
    fonts = fonts[0:cull]
        
    # produce
    with open(fp_dir_temp+sep+fn_temp_font_index,"w") as fio_temp_index, open(fp_dir_temp+sep+fn_temp_font_data,"w") as fio_temp_data:

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

            # data
            label = "font_data_"+str(font["id"])
            pw = (font["dir"]+sep+fn_width).replace(sep,"/")
            pg = (font["dir"]+sep+fn_gfx).replace(sep,"/")
            pi = (font["dir"]+sep+fn_index).replace(sep,"/")
            temp_data = (
                "freedata\n"
                "{0}:\n"
                ".w: incbin \"{1}\"\n"
                ".g: incbin \"{2}\"\n"
                ".i: incbin \"{3}\"\n"
            ).format(label,pw,pg,pi)
                
            # index
            fio_temp_data.write(temp_data)
            with open(font["dir"]+sep+fn_props,"r") as fio_props:
                font_height = json.load(fio_props)["height"]
            temp_index = (
                "db {0}>>16\n"
                "dw {0}_w\n"
                "dw {0}_g\n"
                "dw {0}_i\n"
                "db {1}\n"
            ).format(label,font_height-1)
            fio_temp_index.write(temp_index)

if __name__ == "__main__":
    main()