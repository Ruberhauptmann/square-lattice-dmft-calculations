#!/bin/bash

mu=$1
beta=$2

mkdir -p "${HOME}/dmft_logs/square_lattice/mu_${mu}/beta_${beta}"

qsub -o "${HOME}/dmft_logs/square_lattice/mu_${mu}/beta_${beta}" -N "dmft_square_mu_${mu}_beta_${beta}" code/dmft/jobscript_sge.sh  ${mu} ${beta}
