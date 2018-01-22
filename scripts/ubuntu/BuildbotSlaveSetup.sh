#!/bin/bash

###########################################################
#
#
# Install script for Buildbot slave 0.8.9
#
#
##########################################################

#--------------------------------------------------------
# Install dependent packages
#--------------------------------------------------------

# Inform the user about the next action
echo "Installing the dependent packages python2.7 python-setuptools python-pip...";

# Execute action
sudo apt-get -y install python2.7 python-setuptools python-pip


#--------------------------------------------------------
# Install Buildbot slave
#--------------------------------------------------------

# Inform the user about the next action
echo "Installing Buildbot slave...";

# Execute action
sudo pip install buildbot-slave

# Inform user that Buildbot slave was successfully installed
echo "Buildbot slave was successfully installed."
