#$ -q infinix.q
#$ -l h_vmem=3G
#$ -pe mpi 16
#$ -l h_cpu=20:00:00
#$ -M tsievers@physnet.uni-hamburg.de -m eas
#$ -cwd
#$ -S /bin/bash

module load intel/oneAPI-2021.4
module load anaconda3/2023.03

conda activate datalad

mu=$1
beta=$2

# define DSLOCKFILE & GIT ENV for job.sh
export DSLOCKFILE=${PWD}/.datalad_lock GIT_AUTHOR_NAME=$(git config user.name) GIT_AUTHOR_EMAIL=$(git config user.email) FULLJOBID="mu_${mu}.beta_${beta}.${JOB_ID}"
# use subject specific folder
mkdir ${HOME}//${FULLJOBID}
cd ${HOME}//${FULLJOBID}

# run things
/afs/physnet.uni-hamburg.de/users/th1_we/tsievers/Projects/square-lattice-dmft-computations/code/job.sh \
  /afs/physnet.uni-hamburg.de/users/th1_we/tsievers/Projects/square-lattice-dmft-computations \
  "${mu}" \
  "${beta}"

cd ${HOME}
chmod 777 -R ${HOME}//${FULLJOBID}
rm -fr ${HOME}//${FULLJOBID}
