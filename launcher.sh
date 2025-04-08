#!/bin/bash

#SBATCH -vv
#SBATCH --nodes 1
#SBATCH --mail-user nicolas.jacquemin@epfl.ch
#SBATCH --ntasks 1
#SBATCH --chdir /home/nljacque/jobs/tmp
#SBATCH --output slurm-launcher-%j.out

SCRIPT_VERSION=1.0.6

echo -e "Setting batch directives...\n"

echo "Job Name: $SLURM_JOB_NAME"

echo "CPUs per Task: $SLURM_CPUS_PER_TASK"

echo "Total Tasks: $SLURM_NTASKS"

echo "Job ID: $SLURM_JOBID"

echo "Allocated Memory per CPU: $SLURM_MEM_PER_CPU"

echo "Allocated Memory per Node: $SLURM_MEM_PER_NODE"

echo "Deadline:" $(date -d @$SLURM_JOB_END_TIME)

echo "Log Folder: /home/$(whoami)/jobs/$SLURM_JOBID"

echo -e "\nSetting batch directives finished !\n"

# SCRIPT

SCRIPT=$1

PATH_TO_SCRIPT=~/scripts/$SCRIPT.sh 
	#Absolute or else relative to $PATH_TO_JOB_LOG_DIR

# LOG

echo -e "\nSetting logs...\n"

PATH_TO_JOB_LOG_DIRS=~/jobs

PATH_TO_JOB_LOG_DIR=$PATH_TO_JOB_LOG_DIRS/$SLURM_JOB_ID

mkdir $PATH_TO_JOB_LOG_DIR

cp $(realpath $0) $PATH_TO_JOB_LOG_DIR/launcher.sh

cp $PATH_TO_SCRIPT $PATH_TO_JOB_LOG_DIR

echo -e "Setting logs finished!\n"

# LAUNCHING

echo -e "Launching the job.\n"

srun \
-J $SCRIPT \
--output=$PATH_TO_JOB_LOG_DIR/slurm-%j.out \
bash $PATH_TO_SCRIPT $PATH_TO_JOB_LOG_DIR ${@:2}

echo -e "The job is finished!\n"

echo -e "Moving log files...\n"

mv /home/nljacque/jobs/tmp/slurm*$SLURM_JOB_ID* $PATH_TO_JOB_LOG_DIR

echo -e "Log files can be find in:" $PATH_TO_JOB_LOG_DIR

echo -e "\nMoving log files finished!\n"
