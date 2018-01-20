#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CPUS=$(nproc --all);
INSTALL_DIR_PATH="/usr/local";
USERNAME=$(whoami);
VALGRIND_DIR_REL_PATH="valgrind";
VALGRIND_GIT_URL="git://sourceware.org/git/valgrind.git";

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

printMessage "Setting up valgrind from source...";
printMessage "CPU(s): ${CPUS}";
printMessage "User: ${USERNAME}";

# Install dependencies
printMessage "Installing dependencies...";

${SUDO_CMD} apt update &&   \
${SUDO_CMD} apt install -y  \
    autoconf                \
    automake                \
    g++                     \
    gcc                     \
    git                     \
    make;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Clone valgrind git repository
printMessage "Cloning valgrind git repository...";

rm -rf "${VALGRIND_DIR_REL_PATH}" &&                        \
git clone ${VALGRIND_GIT_URL} "${VALGRIND_DIR_REL_PATH}";
checkReturnCode "Failed to clone valgrind git repository.";

printMessage "Successfully cloned valgrind git repository.";

# Configure valgrind
printMessage "Configuring valgrind...";

cd "${VALGRIND_DIR_REL_PATH}" &&            \
./autogen.sh &&                             \
./configure --prefix="${INSTALL_DIR_PATH}";
checkReturnCode "Failed to configure valgrind.";

printMessage "Successfully configured valgrind.";

# Build valgrind
printMessage "Building valgrind...";

make -j "${CPUS}";
checkReturnCode "Failed to build valgrind.";

printMessage "Successfully built valgrind.";

# Installing valgrind
printMessage "Installing valgrind...";

${SUDO_CMD} make install;
checkReturnCode "Failed to install valgrind.";

printMessage "Succesfully installed valgrind.";

printMessage "Successfully set up valgrind from source.";
