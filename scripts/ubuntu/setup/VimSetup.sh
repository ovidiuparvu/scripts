#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CPUS=$(nproc --all);
CURRENT_DIR_PATH="$(pwd)";
INSTALL_DIR_PATH="/usr/local";
USERNAME=$(whoami);
VIM_DIR_PATH="${CURRENT_DIR_PATH}/vim";
VIM_SRC_DIR_PATH="${VIM_DIR_PATH}/src";
VIM_GITHUB_URL="https://github.com/vim/vim.git";

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

printMessage "Setting up vim from source...";
printMessage "CPU(s): ${CPUS}";
printMessage "User: ${USERNAME}";

# Install dependencies
printMessage "Installing dependencies...";

${SUDO_CMD} apt update &&   \
${SUDO_CMD} apt install -y  \
    g++                     \
    gcc                     \
    git                     \
    libncurses-dev          \
    make                    \
    python-dev              \
    python3-dev             \
    xorg-dev;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Clone vim git repository
printMessage "Cloning vim git repository into the ${VIM_DIR_PATH} directory...";

git clone "${VIM_GITHUB_URL}" "${VIM_DIR_PATH}";
checkReturnCode "Failed to clone vim git repository.";

printMessage "Successfully cloned vim git repository.";

# Configure vim
printMessage "Configuring vim...";

cd "${VIM_SRC_DIR_PATH}" &&         \
CFLAGS="-g -O3"                     \
./configure                         \
    --prefix="${INSTALL_DIR_PATH}"  \
    --enable-cscope                 \
    --enable-fail-if-missing        \
    --enable-gui=auto               \
    --enable-pythoninterp=dynamic   \
    --enable-python3interp=dynamic  \
    --with-features=huge            \
    --with-x;
checkReturnCode "Failed to configure vim.";

printMessage "Successfully configured vim.";

# Build vim
printMessage "Building vim...";

make -j "${CPUS}";
checkReturnCode "Failed to build vim.";

printMessage "Successfully built vim.";

# Install vim
printMessage "Installing vim...";

${SUDO_CMD} make install -j "${CPUS}";
checkReturnCode "Failed to install vim.";

printMessage "Successfully installed vim.";

printMessage "Successfully set up vim from source.";
