import json
from os import sep
from util import error, testfile, getlines, orderlines

def list_header():

    fp_list = ".."+sep+"list"+sep+"headers.txt"
    fp_dir_headers = ".."+sep+"headers"
    fp_dir_temp = ".."+sep+"temp"
    fn_code = "code.asm"
    fn_props = "properties.json"
    fp_temp_index = ".."+sep+"temp"+sep+"header_index.asm"
    fp_temp_code  = ".."+sep+"temp"+sep+"header_code.asm"
    deps = []

    # convert list
    testfile(fp_list)
    with open(fp_list,"r",encoding="utf-8") as fio_list:
        lines = getlines(fio_list)
    headers = orderlines(lines,0x80)
        
    # produce files
    counter = 0
    with open(fp_temp_index,"w") as fio_temp_index, open(fp_temp_code,"w") as fio_temp_code:

        temp_index = (
            "fillbyte $00\n"
        )
        fio_temp_index.write(temp_index)

        for header in headers:

            # empty?
            if not header:
                fio_temp_index.write("fill 2\n")
                continue
            
            # get props
            header_dir_raw = (fp_dir_headers+sep+header["arg"]+sep)
            header_dir = header_dir_raw.replace(sep,"/")
            with open(header_dir_raw+fn_props,"r") as fio_props:
                props = json.load(fio_props)
            deps.append(header_dir_raw+fn_props)

            # code
            label = "header_code_"+str(header["id"])
            temp_code = (
                "namespace \"{0}\"\n"
                "incsrc \"{1}\"\n"
                "namespace off\n"
            ).format(label,header_dir+fn_code)
            fio_temp_code.write(temp_code)
            deps.append(header_dir_raw+fn_code)
                
            # index
            temp_index = (
                "dw {0}_{1}\n"
            ).format(label,props["labels"]["main"])
            fio_temp_index.write(temp_index)

            counter += 1

    print("prep'd "+str(counter)+" headers successfully.")
    return deps