#!/bin/bash

# fail whenever something is fishy, use -x to get verbose logfiles
set -e -u -x

# we pass arbitrary arguments via job scheduler and can use them as variables
dssource="$1"
U="$2"
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
  -m "Compute U=${U}, beta=${beta}" \
  --explicit \
  -o "dmft_results/U_${U}/beta_${beta}.zip" \
  "sh code/dmft/run_dmft.sh $U $beta"

# push, with filelocking as a safe-guard
flock --verbose "${DSLOCKFILE}" datalad push --to origin

# Done - job handler should clean up workspace
echo SUCCESS
