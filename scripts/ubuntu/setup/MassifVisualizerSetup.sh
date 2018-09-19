#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CPUS=$(nproc --all);
CURRENT_DIR_PATH="$(pwd)";
MASSIF_VISUALIZER_DIR_PATH="${CURRENT_DIR_PATH}/massif-visualizer";
MASSIF_VISUALIZER_BUILD_DIR_PATH="${MASSIF_VISUALIZER_DIR_PATH}/build";
MASSIF_VISUALIZER_GITHUB_URL="https://github.com/KDE/massif-visualizer.git";
INSTALL_DIR_PATH="/usr/local";
USERNAME=$(whoami);

# If the current user is not "root" then there is a need for an explicit sudo
# command
if [[ $(id -u) -ne 0 ]]; then
    SUDO_CMD="sudo";
fi


# =============================================================================
# Functions
# =============================================================================

# Print the given message to the standard output.
#
# The given message will be prefixed by the current time when printed to the
# standard output.
#
# Arguments:
#   $1 - A string variable recording the given message.
printMessage() {
    local currentTime;

    currentTime=$(date +"%Y-%m-%d %H:%M:%S");

    echo -e "${currentTime}\\t${1}";
}

# Check the return code of the most recently executed command.
#
# If the return code is non-zero then exit with the given error message.
#
# Arguments:
#   $1 - A string variable recording the given error message.
checkReturnCode() {
    if [[ $? -ne 0 ]]; then
        printMessage "$1";

        exit 1;
    fi
}


# =============================================================================
# Main
# =============================================================================

printMessage "Setting up massif-visualizer from source...";
printMessage "CPU(s): ${CPUS}";
printMessage "User: ${USERNAME}";

# Install dependencies
printMessage "Installing dependencies...";

${SUDO_CMD} apt update &&   \
${SUDO_CMD} apt install -y  \
    cmake                   \
    extra-cmake-modules     \
    g++                     \
    gcc                     \
    gettext                 \
    git                     \
    libkchart-dev           \
    libkf5archive-dev       \
    libkf5configwidgets-dev \
    libkf5coreaddons-dev    \
    libkf5i18n-dev          \
    libkf5itemmodels-dev    \
    libkf5itemviews-dev     \
    libkf5kio-dev           \
    libkf5parts-dev         \
    libkf5solid-dev         \
    libkf5threadweaver-dev  \
    libkf5windowsystem-dev  \
    libqt5svg5-dev          \
    libqt5xmlpatterns5-dev  \
    make;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Clone massif-visualizer git repository
printMessage "Cloning massif-visualizer git repository...";

rm -rf "${MASSIF_VISUALIZER_DIR_PATH}" &&                                                       \
git clone --recurse-submodules "${MASSIF_VISUALIZER_GITHUB_URL}" "${MASSIF_VISUALIZER_DIR_PATH}";
checkReturnCode "Failed to clone massif-visualizer git repository.";

printMessage "Successfully cloned massif-visualizer git repository.";

# Configure massif-visualizer
printMessage "Configuring massif-visualizer...";

rm -rf "${MASSIF_VISUALIZER_BUILD_DIR_PATH}" &&     \
mkdir -p "${MASSIF_VISUALIZER_BUILD_DIR_PATH}" &&   \
cd "${MASSIF_VISUALIZER_BUILD_DIR_PATH}" &&         \
cmake                                               \
    -DCMAKE_BUILD_TYPE="Release"                    \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR_PATH}"    \
    ..;
checkReturnCode "Failed to configure massif-visualizer.";

printMessage "Successfully configured massif-visualizer.";

# Build massif-visualizer
printMessage "Building massif-visualizer...";

make -j "${CPUS}";
checkReturnCode "Failed to build massif-visualizer.";

printMessage "Successfully built massif-visualizer.";

# Install massif-visualizer
printMessage "Installing massif-visualizer...";

${SUDO_CMD} make install;
checkReturnCode "Failed to install massif-visualizer.";

printMessage "Successfully installed massif-visualizer.";

printMessage "Successfully set up massif-visualizer from source.";
