#!/bin/bash

###########################################################
#
#
# Xerces 3.1.1 setup
#
#
###########################################################

# Starting setup of Xerces 
echo "Setting up Xerces..."


#----------------------------------------------------------
# Installing dependent packages
#----------------------------------------------------------

# Inform the user about the next action
echo "Installing the dependent packages build-essentials g++ gcc..."

# Execute the action
sudo apt-get -y install build-essentials g++ gcc


#----------------------------------------------------------
# Installing Xerces
#----------------------------------------------------------

# Inform the user about the next action
echo "Downloading and installing Xerces..."

# Constant values definitions
FOLDER_NAME="Xerces"

# Create a new folder for storing the source code
mkdir ${FOLDER_NAME}

# Change directory
cd ${FOLDER_NAME}

# Download source code
wget http://mirror.vorboss.net/apache//xerces/c/3/sources/xerces-c-3.1.1.tar.gz

# Extract archive
tar -xvzf xerces-c-3.1.1.tar.gz

# Change directory
cd xerces-c-3.1.1

# Configure Xerces for compilation
./configure

# Compile the project
make

# Install Xerces in the default location
sudo make install

# Return to the parent directory
cd ../../

# Remove all source files
rm -rf ${FOLDER_NAME}

# Inform user that Xerces was successfully installed
echo "Xerces was successfully installed."
