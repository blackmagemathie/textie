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

    index_labels = ["narg","flag","main_lo","main_hi","wrap_lo","wrap_hi"]

    # convert list
    testfile(fp_list)
    with open(fp_list,"r",encoding="utf-8") as fio_list:
        lines = getlines(fio_list)
    commands = orderlines(lines,0x100)
        
    # produce files
    counter = 0

    with open(fp_temp_index,"w") as fio_temp_index, open(fp_temp_code,"w") as fio_temp_code:

        temp_index = (
            "freedata\n"
        )
        fio_temp_index.write(temp_index)

        for id,command in enumerate(commands):

            # empty?
            if not command:
                commands[id] = {}
                for index_label in index_labels:
                    commands[id][index_label] = 0
                continue
            
            # get props
            command_dir_raw = (fp_dir_commands+sep+command["arg"]+sep)
            command_dir = command_dir_raw.replace(sep,"/")
            with open(command_dir_raw+fn_props,"r") as fio_props:
                props = json.load(fio_props)
            deps.append(command_dir_raw+fn_props)

            # code
            label = "command_code_"+str(id)
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
            commands[id]["flag"] = flags

            commands[id]["narg"] = sum(arg["len"] for arg in props["args"])

            label_main = "{0}_{1}".format(label,props["labels"]["main"])
            commands[id]["main_lo"] = label_main
            commands[id]["main_hi"] = label_main+">>8"

            if props["wrap"]=="run":
                label_wrap = "{0}_{1}".format(label,props["labels"]["wrap"])
                commands[id]["wrap_lo"] = label_wrap
                commands[id]["wrap_hi"] = label_wrap+">>8"
            else:
                commands[id]["wrap_lo"] = 0
                commands[id]["wrap_hi"] = 0
                
            counter += 1

        for index_label in index_labels:

            temp_index = (
                "command_index_{label}:\n"
                "db {values}\n"
            ).format(
                label = index_label,
                values = ",".join(str(command[index_label]) for command in commands)
            )
            fio_temp_index.write(temp_index)

    print("prep'd "+str(counter)+" commands successfully.")
    return deps