#!/bin/bash

U=$1
beta=$2

mkdir -p "${HOME}/dmft_logs/square_lattice/U_${U}/beta_${beta}"

qsub -o "${HOME}/dmft_logs/square_lattice/U_${U}/beta_${beta}" -N "dmft_square_U_${U}_beta_${beta}" code/dmft/jobscript_sge.sh  ${U} ${beta}
