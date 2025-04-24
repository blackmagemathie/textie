import json
from os import sep
from util import error, testfile, getlines, orderlines

def list_box():

    fp_list = ".."+sep+"list"+sep+"boxes.txt"
    fp_dir_boxes = ".."+sep+"boxes"
    fp_dir_temp = ".."+sep+"temp"
    fn_code = "code.asm"
    fn_props = "properties.json"
    fp_temp_index = ".."+sep+"temp"+sep+"box_index.asm"
    fp_temp_code  = ".."+sep+"temp"+sep+"box_code.asm"
    deps = []

    index_labels = [
        "draw_init",
        "draw_main",
        "clear_init",
        "clear_main",
        "erase_init",
        "erase_main",
    ]

    # convert list
    testfile(fp_list)
    with open(fp_list,"r",encoding="utf-8") as fio_list:
        lines = getlines(fio_list)
    boxes = orderlines(lines,0x80)
        
    # produce files
    counter = 0

    with open(fp_temp_index,"w") as fio_temp_index, open(fp_temp_code,"w") as fio_temp_code:

        fio_temp_index.write("freedata\n")

        for id,box in enumerate(boxes):

            # empty?
            if not box:
                boxes[id] = {}
                for index_label in index_labels:
                    boxes[id][index_label] = 0
                continue
            
            # get props
            box_dir_raw = (fp_dir_boxes+sep+box["arg"]+sep)
            box_dir = box_dir_raw.replace(sep,"/")
            with open(box_dir_raw+fn_props,"r") as fio_props:
                props = json.load(fio_props)
            deps.append(box_dir_raw+fn_props)

            # code
            label = "box_code_"+str(id)
            temp_code = (
                "namespace \"{0}\"\n"
                "incsrc \"{1}\"\n"
                "namespace off\n"
            ).format(label,box_dir+fn_code)
            fio_temp_code.write(temp_code)
            deps.append(box_dir_raw+fn_code)
                
            # index
            for index_label in index_labels:
                boxes[id][index_label] = "{0}_{1}".format(label,props["labels"][index_label])
                
            counter += 1

        for index_label in index_labels:

            temp_index = (
                "box_index_{label}:\n"
                "dw {values}\n"
            ).format(
                label = index_label,
                values = ",".join(str(box[index_label]) for box in boxes)
            )
            fio_temp_index.write(temp_index)

    print("prep'd "+str(counter)+" boxes successfully.")
    return deps