#!/bin/bash

# fail whenever something is fishy, use -x to get verbose logfiles
set -e -u -x

# we pass arbitrary arguments via job scheduler and can use them as variables
dssource="$1"
mu="$2"
beta="$3"

# go into unique location
#cd /tmp
# clone the analysis dataset. flock makes sure that this does not interfere
# with another job finishing and pushing results back at the same time
flock --verbose "${DSLOCKFILE}" datalad clone "${dssource}" ds
cd ds

# announce the clone to be temporary
git annex dead here
# checkout a unique branch
git checkout -b "job-${FULLJOBID}"

# run the job
datalad run \
  -m "Compute mu=${mu}, beta=${beta}" \
  --explicit \
  -o "dmft_results/mu_${mu}/beta_${beta}.zip" \
  "sh code/run_dmft.sh $mu $beta"

# push, with filelocking as a safe-guard
flock --verbose "${DSLOCKFILE}" datalad push --to origin

# Done - job handler should clean up workspace
echo SUCCESS
