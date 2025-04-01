import json
from os import sep
from util import error, testfile, getlines, orderlines

def list_command():

    fp_list = ".."+sep+"list"+sep+"commands.txt"
    fp_dir_commands = ".."+sep+"commands"
    fp_dir_temp = ".."+sep+"temp"
    fn_code = "code.asm"
    fn_props = "properties.json"
    fp_temp_index = ".."+sep+"temp"+sep+"command_index.asm"
    fp_temp_code  = ".."+sep+"temp"+sep+"command_code.asm"
    deps = []

    # convert list
    testfile(fp_list)
    with open(fp_list,"r",encoding="utf-8") as fio_list:
        lines = getlines(fio_list)
    commands = orderlines(lines,0x20)
        
    # produce files
    counter = 0
    with open(fp_temp_index,"w") as fio_temp_index, open(fp_temp_code,"w") as fio_temp_code:

        temp_index = (
            "fillbyte $00\n"
        )
        fio_temp_index.write(temp_index)

        for command in commands:

            # empty?
            if not command:
                fio_temp_index.write("fill 8\n")
                continue
            
            # get props
            command_dir_raw = (fp_dir_commands+sep+command["arg"]+sep)
            command_dir = command_dir_raw.replace(sep,"/")
            with open(command_dir_raw+fn_props,"r") as fio_props:
                props = json.load(fio_props)
            deps.append(command_dir_raw+fn_props)

            # code
            label = "command_code_"+str(command["id"])
            temp_code = (
                "namespace \"{0}\"\n"
                "incsrc \"{1}\"\n"
                "namespace off\n"
            ).format(label,command_dir+fn_code)
            fio_temp_code.write(temp_code)
            deps.append(command_dir_raw+fn_code)
                
            # index
            flags = 0
            flags += 1 if props["chainable"] else 0
            flags += 2 if props["wrap"]=="end" else 0
            flags += 4 if props["wrap"]=="ignore" else 0
            temp_index = (
                "dw {label}_{main}\n"
                "db {nargs}\n"
                "db {flags}\n"
                "dw {wrap}\n"
                "dw 0\n"
            ).format(
                label = label,
                main = props["labels"]["main"],
                nargs = sum(arg["len"] for arg in props["args"]),
                flags = str(flags),
                wrap = label+"_"+props["labels"]["wrap"] if props["wrap"]=="run" else 0
            )
            fio_temp_index.write(temp_index)

            counter += 1

    print("prep'd "+str(counter)+" commands successfully.")
    return deps