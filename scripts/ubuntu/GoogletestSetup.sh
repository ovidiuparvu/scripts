#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CPUS=$(nproc --all);
CURRENT_DIR_PATH="$(pwd)";
GOOGLETEST_DIR_PATH="${CURRENT_DIR_PATH}/googletest";
GOOGLETEST_GITHUB_URL="https://github.com/google/googletest.git";
GOOGLETEST_INSTALL_DIR_PATH="${GOOGLETEST_DIR_PATH}/install";
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

printMessage "Setting up googletest from source...";
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
    git                     \
    make;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Clone googletest git repository
printMessage "Cloning googletest git repository...";

rm -rf "${GOOGLETEST_DIR_PATH}" &&                                                  \
git clone --recurse-submodules "${GOOGLETEST_GITHUB_URL}" "${GOOGLETEST_DIR_PATH}";
checkReturnCode "Failed to clone googletest git repository.";

printMessage "Successfully cloned googletest git repository.";

# Configure googletest
printMessage "Configuring googletest...";

cd "${GOOGLETEST_DIR_PATH}" &&                                          \
cmake                                                                   \
    -DCMAKE_INSTALL_BINDIR="${GOOGLETEST_INSTALL_DIR_PATH}/bin"         \
    -DCMAKE_INSTALL_INCLUDEDIR="${GOOGLETEST_INSTALL_DIR_PATH}/include" \
    -DCMAKE_INSTALL_LIBDIR="${GOOGLETEST_INSTALL_DIR_PATH}/lib"         \
    -DBUILD_GTEST="ON"                                                  \
    -DBUILD_GMOCK="ON";
checkReturnCode "Failed to configure googletest.";

printMessage "Successfully configured googletest.";

# Build googletest
printMessage "Building googletest...";

make -j "${CPUS}";
checkReturnCode "Failed to build googletest.";

printMessage "Successfully built googletest.";

# Install googletest
printMessage "Installing googletest...";

mkdir -p "${GOOGLETEST_INSTALL_DIR_PATH}" &&    \
make install;
checkReturnCode "Failed to install googletest.";

printMessage "Successfully installed googletest.";

printMessage "Successfully set up googletest from source.";
