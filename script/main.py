from list_font import list_font
from list_header import list_header
from list_command import list_command

def run_all():

    deps = []

    # run scripts
    deps.extend(list_font())
    deps.extend(list_header())
    deps.extend(list_command())

    # write deps
    with open(".dependencies","w") as fio_deps:
        fio_deps.write("\n".join(deps))

if __name__ == "__main__":

    run_all()
    exit(0)