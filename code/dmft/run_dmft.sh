#!/bin/bash

mu=$1
beta=$2

CODE_DIR=${PWD}/code

# Prepare result directory with input files
mkdir -p "dmft_results/mu_${mu}/beta_${beta}"

python3 code/dmft/generate_inputs.py --mu ${mu} --beta ${beta}
cp "input/mu_${mu}/beta_${beta}/dmft.input" "dmft_results/mu_${mu}/beta_${beta}/"
cp "input/HR.txt" "dmft_results/mu_${mu}/beta_${beta}/"

cd "dmft_results/mu_${mu}/beta_${beta}"

# Run the actual DMFT loop in the result directory (so all files get placed there)
"${CODE_DIR}"/dmft/dmft_loop.sh

# Zip up files
cd ../
zip -r "beta_${beta}.zip" "beta_${beta}/"
