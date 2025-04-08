#!/bin/bash

SCRIPT_VERSION=1.0.3

USERNAME=$(whoami)

echo -e "Setting apptainer container...\n"

echo "USERNAME:" $USERNAME

PATH_TO_HOST_WORKING_DIRECTORY=$2

echo "PATH_TO_HOST_WORKING_DIRECTORY:" $PATH_TO_HOST_WORKING_DIRECTORY

IMAGE=$3

PATH_TO_THE_IMAGE=~/images/"$IMAGE".sif

echo "IMAGE:" $PATH_TO_THE_IMAGE

SCRIPT=$4

PATH_TO_HOST_SCRIPT_DIRECTORY=~/scripts

PATH_TO_SCRIPT_HOST=$PATH_TO_HOST_SCRIPT_DIRECTORY/$SCRIPT.sh

PATH_TO_SCRIPT_CONTAINER=$PATH_TO_SCRIPT_HOST

echo "SCRIPT:" $PATH_TO_SCRIPT_CONTAINER

#LOG

PATH_TO_JOB_LOG_DIR=$1

cp $PATH_TO_SCRIPT_HOST $PATH_TO_JOB_LOG_DIR

echo -e "\nSetting apptainer container finished!\n"

echo -e "Creating and executing script within apptainer container...\n"

if [ -z "$5" ]
	then

		apptainer exec \
		--bind $PATH_TO_HOST_WORKING_DIRECTORY:/data \
		$PATH_TO_THE_IMAGE \
		bash $PATH_TO_SCRIPT_CONTAINER $PATH_TO_JOB_LOG_DIR ${@:5} 

	else

		echo -e "\nInside micromamba environment...\n"

		MICROMAMBA_ENV=$5

		echo "ENVIRONMENT:" $MICROMAMBA_ENV

		apptainer exec \
		--bind $PATH_TO_HOST_WORKING_DIRECTORY:/data \
		$PATH_TO_THE_IMAGE \
		micromamba run -n $MICROMAMBA_ENV bash $PATH_TO_SCRIPT_CONTAINER $PATH_TO_JOB_LOG_DIR ${@:6}

		echo -e "Closing micromamba environment.\n"

fi

echo -e "Creating and executing script within apptainer container done!\n"
