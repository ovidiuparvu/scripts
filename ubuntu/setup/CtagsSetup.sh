#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CPUS=$(nproc --all);
CURRENT_DIR_PATH="$(pwd)";
CTAGS_DIR_PATH="${CURRENT_DIR_PATH}/ctags";
CTAGS_GITHUB_URL="https://github.com/universal-ctags/ctags.git";
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

printMessage "Setting up ctags from source...";
printMessage "CPU(s): ${CPUS}";
printMessage "User: ${USERNAME}";

# Install dependencies
printMessage "Installing dependencies...";

${SUDO_CMD} apt update &&   \
${SUDO_CMD} apt install -y  \
    autoconf                \
    autotools-dev           \
    g++                     \
    gcc                     \
    git                     \
    make                    \
    pkg-config;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Clone ctags git repository
printMessage "Cloning ctags git repository...";

rm -rf "${CTAGS_DIR_PATH}" &&                                           \
git clone --recurse-submodules "${CTAGS_GITHUB_URL}" "${CTAGS_DIR_PATH}";
checkReturnCode "Failed to clone ctags git repository.";

printMessage "Successfully cloned ctags git repository.";

# Configure ctags
printMessage "Configuring ctags...";

cd "${CTAGS_DIR_PATH}" &&           \
./autogen.sh &&                     \
./configure                         \
    --prefix="${INSTALL_DIR_PATH}";
checkReturnCode "Failed to configure ctags.";

printMessage "Successfully configured ctags.";

# Build ctags
printMessage "Building ctags...";

make -j "${CPUS}";
checkReturnCode "Failed to build ctags.";

printMessage "Successfully built ctags.";

# Install ctags
printMessage "Installing ctags...";

${SUDO_CMD} make install;
checkReturnCode "Failed to install ctags.";

printMessage "Successfully installed ctags.";

printMessage "Successfully set up ctags from source.";
