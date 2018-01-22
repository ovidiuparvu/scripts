#!/bin/bash

###########################################################
#
#
# Install script for Buildbot master 0.8.9
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
# Install Buildbot master
#--------------------------------------------------------

# Inform the user about the next action
echo "Installing Buildbot master...";

# Execute action
sudo pip install buildbot

# Inform user that Buildbot master was successfully installed
echo "Buildbot master was successfully installed."
