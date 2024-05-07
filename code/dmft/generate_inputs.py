from argparse import ArgumentParser
from pathlib import Path

import jinja2

parser = ArgumentParser()
parser.add_argument("-m", "--mu", help="Value for chemical potential", type=float)
parser.add_argument("-b", "--beta", help="Value for beta", type=float)

args = parser.parse_args()

xmu = args.mu
beta = args.beta
Nmesh = 100 * beta

mu_path = Path(f"input/mu_{xmu}")

tmpl_loader = jinja2.FileSystemLoader(searchpath="input")
tmpl_env = jinja2.Environment(loader=tmpl_loader)
template = tmpl_env.get_template("dmft.input.template")

data = {
    "beta": f"{beta:.11f}",
    "Nmesh": f"{Nmesh}",
    "xmu": f"{xmu:.15f}",
}

mu_path.joinpath(f"beta_{beta}").mkdir(exist_ok=True, parents=True)
with open(mu_path.joinpath(f"beta_{beta}", "dmft.input"), "w") as fout:
    fout.write(template.render(**data))
