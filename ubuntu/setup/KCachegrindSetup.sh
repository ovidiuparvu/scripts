#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CPUS=$(nproc --all);
INSTALL_DIR_PATH="/usr/local";
KCACHEGRIND_DIR_REL_PATH="kcachegrind";
KCACHEGRIND_GIT_URL="git://anongit.kde.org/kcachegrind";
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

printMessage "Setting up kcachegrind from source...";
printMessage "CPU(s): ${CPUS}";
printMessage "User: ${USERNAME}";

# Install dependencies
printMessage "Installing dependencies...";

# TODO: If you are using version 16.04 or earlier of Ubuntu then replace
# libkf5doctools-dev with kdoctools-dev, and libkf5kio-dev with kio-dev in the
# dependencies list below
${SUDO_CMD} apt update &&   \
${SUDO_CMD} apt install -y  \
    binutils                \
    cmake                   \
    extra-cmake-modules     \
    g++                     \
    gcc                     \
    gettext                 \
    git                     \
    graphviz                \
    kdelibs5-dev            \
    libkf5archive-dev       \
    libkf5config-dev        \
    libkf5coreaddons-dev    \
    libkf5doctools-dev      \
    libkf5kio-dev           \
    libkf5widgetsaddons-dev \
    libkf5xmlgui-dev        \
    make;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Clone kcachegrind git repository
printMessage "Cloning kcachegrind git repository...";

${SUDO_CMD} rm -rf "${KCACHEGRIND_DIR_REL_PATH}" &&                         \
git clone ${KCACHEGRIND_GIT_URL} "${KCACHEGRIND_DIR_REL_PATH}";
checkReturnCode "Failed to clone kcachegrind git repository.";

printMessage "Successfully cloned kcachegrind git repository.";

# Configure kcachegrind
printMessage "Configuring kcachegrind...";

cd "${KCACHEGRIND_DIR_REL_PATH}" &&                 \
rm -rf build &&                                     \
mkdir build &&                                      \
cd build &&                                         \
cmake                                               \
    -G "Unix Makefiles"                             \
    -DCMAKE_BUILD_TYPE="Release"                    \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR_PATH}"    \
    ..;
checkReturnCode "Failed to configure kcachegrind.";

printMessage "Successfully configured kcachegrind.";

# Build kcachegrind
printMessage "Building kcachegrind...";

make -j "${CPUS}";
checkReturnCode "Failed to build kcachegrind.";

printMessage "Successfully built kcachegrind.";

# Install kcachegrind
printMessage "Installing kcachegrind...";

${SUDO_CMD} make install;
checkReturnCode "Failed to install kcachegrind.";

printMessage "Successfully installed kcachegrind.";

printMessage "Successfully set up kcachegrind from source.";
