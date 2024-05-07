# DMFT calculations on the attractive Hubbard model on a square lattice

## General

Need self and ctqmc compiled, also a version of init with the number of processors, so e.g. init_48

Need to set up a conda environment with datalad and jinja2 (for templating the input file) installed

In datalad command: --explicit to only save the results, not the changes to .gitattributes etc.

# TODO

- define conda environemt with datalad and jinja2
- Docs
  - Better overview for all the parts in code/
  - Better readme:
    - How does a run go?
    - How to acquire the results?
- put everything into a bootstrapping script/cookiecutter
