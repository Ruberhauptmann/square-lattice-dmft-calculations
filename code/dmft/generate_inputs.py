from argparse import ArgumentParser
from pathlib import Path

import jinja2

parser = ArgumentParser()
parser.add_argument("-U", "--interaction", help="Value for interaction", type=float)
parser.add_argument("-b", "--beta", help="Value for beta", type=float)

args = parser.parse_args()

interaction = args.interaction
beta = args.beta
Nmesh = 100 * beta

U_path = Path(f"input/U_{interaction}")

tmpl_loader = jinja2.FileSystemLoader(searchpath="input")
tmpl_env = jinja2.Environment(loader=tmpl_loader)
template = tmpl_env.get_template("dmft.input.template")

data = {
    "beta": f"{beta:.11f}",
    "Nmesh": f"{Nmesh}",
    "U": f"{interaction:.15f}",
}

U_path.joinpath(f"beta_{beta}").mkdir(exist_ok=True, parents=True)
with open(U_path.joinpath(f"beta_{beta}", "dmft.input"), "w") as fout:
    fout.write(template.render(**data))
