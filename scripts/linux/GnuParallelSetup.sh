#!/bin/bash

###########################################################
#
#
# Gnu parallel (2014.07.22) setup
#
#
###########################################################

# Starting setup of Gnu parallel
echo "Setting up Gnu Parallel..."


#----------------------------------------------------------
# Installing dependent packages
#----------------------------------------------------------

# Inform the user about the next action
echo "Installing the dependent packages build-essentials g++ gcc..."

# Execute the action
sudo apt-get -y install build-essentials g++ gcc


#----------------------------------------------------------
# Installing Gnu parallel
#----------------------------------------------------------

# Inform the user about the next action
echo "Downloading and installing Gnu parallel..."

# Constant values definitions
FOLDER_NAME="GnuParallel"

# Create a new folder for storing the source code
mkdir ${FOLDER_NAME}

# Change directory
cd ${FOLDER_NAME}

# Download source code
wget http://ftp.gnu.org/gnu/parallel/parallel-20140722.tar.bz2 

# Extract archive
tar -xvjf parallel-20140722.tar.bz2

# Change directory
cd parallel-20140722

# Configure Gnu parallel for compilation
./configure

# Compile the project
make

# Install Gnu parallel in the default location
sudo make install

# Return to the parent directory
cd ../../

# Remove all source files
rm -rf ${FOLDER_NAME}

# Inform user that Gnu parallel was successfully installed
echo "Gnu parallel was successfully installed."
