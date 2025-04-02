from os.path import isfile

def error(message:str):

    print("[ERROR] "+message)
    exit(1)

def testfile(path:str):

    if not isfile(path):
        error("\""+path+"\" not found")

def getlines(fio):

    lines = []

    for i,line in enumerate(fio):
        line = line.strip()
        # skip empty
        if not line:
            continue
        # correct # of args?
        line = line.split(maxsplit=1)
        if len(line)!=2:
            error("invalid syntax @ line "+str(i))
        # append
        lines.append({
            "id": int(line[0].lower(),16),
            "arg": line[1]
        })
    # no lines?
    if len(lines)<1:
        error("empty list")

    return lines

def orderlines(lines:list[dict],list_size:int):

    # set in list, check duped ids
    o = [None for i in range(0,list_size)]
    for line in lines:
        id = line["id"]
        if o[id]:
            error("duplicate id: "+str(id))
        o[id] = line

    # trim end
    trim = list_size-1
    while trim>0:
        if o[trim]:
            trim += 1
            break
        trim -= 1
    o = o[0:trim]

    return o