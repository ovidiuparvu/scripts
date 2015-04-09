#!/bin/bash

###########################################################
#
#
# OpenCV 2.4.10 setup
#
#
###########################################################

# Starting setup of OpenCV 2.4.10
echo "Setting up OpenCV 2.4.10..."


#----------------------------------------------------------
# Installing dependent packages
#----------------------------------------------------------

# Inform the user about the next action
echo "Installing the dependent packages libopencv-dev build-essential cmake git libgtk2.0-dev pkg-config python-dev python-numpy libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libtiff4-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev libtbb-dev libqt4-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils unzip..."

# Execute the action
sudo apt-get -y install libopencv-dev build-essential cmake git libgtk2.0-dev pkg-config python-dev python-numpy libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libtiff4-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev libtbb-dev libqt4-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils unzip


#----------------------------------------------------------
# Installing OpenCV
#----------------------------------------------------------

# Inform the user about the next action
echo "Downloading and installing the OpenCV 2.4.10 library..."

# Constant values definitions
FOLDER_NAME="OpenCV2.4.10"

# Create a new folder for storing the source code
mkdir ${FOLDER_NAME}

# Change directory
cd ${FOLDER_NAME}

# Download source code
wget http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.10/opencv-2.4.10.zip

# Extract archive
unzip opencv-2.4.10.zip

# Change directory
cd opencv-2.4.10

# Create a build directory
mkdir build

# Change directory
cd build

# Build the project using CMake
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D WITH_QT=ON -D WITH_OPENGL=ON ..

# Compile the project
make -j `nproc`

# Install the libraries in the appropriate folder
sudo make install

# Add the OpenCV libraries path to the default Ubuntu library search path
sudo /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'

# Update the default Ubuntu library search paths
sudo ldconfig

# Return to the parent directory
cd ../../../

# Remove all source files
rm -rf ${FOLDER_NAME}

# Inform user that OpenCV 2.4.10 was successfully installed
echo "OpenCV 2.4.10 was successfully installed."
