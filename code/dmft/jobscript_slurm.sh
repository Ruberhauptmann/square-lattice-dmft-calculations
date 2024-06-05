#!/bin/bash -x
### If you need a compute time project for job submission set here
#SBATCH --account=FIXME
#SBATCH --mail-user=FIXME
#SBATCH --mail-type=END
#SBATCH --job-name=FIXME
#SBATCH --output=logs/processing-out.%j
#SBATCH --error=logs/processing-err.%j
### If there's a time limit for job runs, set (max) here
#SBATCH --time=24:00:00
#SBATCH --ntasks-per-node=1
### If specific partitions are available i.e. with more RAM define here
#SBATCH --partition=asterix-long
#SBATCH --nodes=1

### Define number of jobs that arer run simultaneously
srun parallel --delay 0.2  -a code/all.jobs --FIXME

wait

#$ -q infinix.q
#$ -l h_vmem=3G
#$ -pe mpi 16
#$ -l h_cpu=30:00:00
#$ -M tsievers@physnet.uni-hamburg.de -m eas
#$ -cwd
#$ -S /bin/bash

module load intel/oneAPI-2021.4
module load anaconda3/2023.03

conda activate datalad

U=$1
beta=$2

# define DSLOCKFILE & GIT ENV for job.sh
export DSLOCKFILE=${PWD}/.datalad_lock GIT_AUTHOR_NAME=$(git config user.name) GIT_AUTHOR_EMAIL=$(git config user.email) FULLJOBID="U_${U}.beta_${beta}.${JOB_ID}"
# use subject specific folder
mkdir ${HOME}//${FULLJOBID}
cd ${HOME}//${FULLJOBID}

# run things
/afs/physnet.uni-hamburg.de/users/th1_we/tsievers/Projects/square-lattice-dmft-computations/code/dmft/job.sh \
  /afs/physnet.uni-hamburg.de/users/th1_we/tsievers/Projects/square-lattice-dmft-computations \
  "${U}" \
  "${beta}"

cd ${HOME}
chmod 777 -R ${HOME}//${FULLJOBID}
rm -fr ${HOME}//${FULLJOBID}
