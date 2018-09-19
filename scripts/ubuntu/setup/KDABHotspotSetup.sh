#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CPUS=$(nproc --all);
CURRENT_DIR_PATH="$(pwd)";
HOTSPOT_DIR_PATH="${CURRENT_DIR_PATH}/hotspot";
HOTSPOT_BUILD_DIR_PATH="${HOTSPOT_DIR_PATH}/build";
HOTSPOT_GITHUB_URL="https://github.com/KDAB/hotspot.git";
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

printMessage "Setting up KDAB hotspot from source...";
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
    libelf-dev              \
    libdw-dev               \
    libkf5configwidgets-dev \
    libkf5coreaddons-dev    \
    libkf5i18n-dev          \
    libkf5itemmodels-dev    \
    libkf5itemviews-dev     \
    libkf5kio-dev           \
    libkf5solid-dev         \
    libkf5threadweaver-dev  \
    libkf5windowsystem-dev  \
    make;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Clone KDAB hotspot git repository
printMessage "Cloning KDAB hotspot git repository...";

rm -rf "${HOTSPOT_DIR_PATH}" &&                                             \
git clone --recurse-submodules ${HOTSPOT_GITHUB_URL} "${HOTSPOT_DIR_PATH}";
checkReturnCode "Failed to clone KDAB hotspot git repository.";

printMessage "Successfully cloned KDAB hotspot git repository.";

# Configure KDAB hotspot
printMessage "Configuring KDAB hotspot...";

rm -rf "${HOTSPOT_BUILD_DIR_PATH}" &&               \
mkdir -p "${HOTSPOT_BUILD_DIR_PATH}" &&             \
cd "${HOTSPOT_BUILD_DIR_PATH}" &&                   \
cmake                                               \
    -DCMAKE_BUILD_TYPE="Release"                    \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR_PATH}"    \
    ..;
checkReturnCode "Failed to configure KDAB hotspot.";

printMessage "Successfully configured KDAB hotspot.";

# Build KDAB hotspot
printMessage "Building KDAB hotspot...";

make -j "${CPUS}";
checkReturnCode "Failed to build KDAB hotspot.";

printMessage "Successfully built KDAB hotspot.";

# Test KDAB hotspot
printMessage "Testing KDAB hotspot...";

make test;
checkReturnCode "Failed to successfully test KDAB hotspot.";

printMessage "Successfully tested KDAB hotspot.";

# Install KDAB hotspot
printMessage "Installing KDAB hotspot...";

${SUDO_CMD} make install;
checkReturnCode "Failed to install KDAB hotspot.";

printMessage "Successfully installed KDAB hotspot.";

printMessage "Successfully set up KDAB hotspot from source.";
