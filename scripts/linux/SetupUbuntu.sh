#!/bin/bash

# Add the required repositories

sudo add-apt-repository ppa:webupd8team/java

# Update the list of available packages

sudo apt-get update

# Install different packages I usually need

sudo apt-get install krusader p7zip unzip ia32-libs-multiarch openssh-server mailutils graphviz-dev graphviz git texlive-full flex bison oracle-java7-installer python2.7 python-lxml python-setuptools libopencv-dev build-essential libgtk2.0-dev pkg-config python-dev python-numpy libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libtiff4-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev libtbb-dev libqt4-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils
