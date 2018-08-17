#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CPUS=$(nproc --all);
CURRENT_DIR_PATH="$(pwd)";
INSTALL_DIR_PATH="/usr/local";
USERNAME=$(whoami);

BINUTILS_GDB_DIR_PATH="${CURRENT_DIR_PATH}/binutils-gdb";
BINUTILS_GDB_BUILD_DIR_PATH="${BINUTILS_GDB_DIR_PATH}/build";
BINUTILS_GDB_GITHUB_URL="git://sourceware.org/git/binutils-gdb.git";

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

printMessage "Setting up gdb from source...";
printMessage "CPU(s): ${CPUS}";
printMessage "User: ${USERNAME}";

# Install dependencies
printMessage "Installing dependencies...";

${SUDO_CMD} apt update &&   \
${SUDO_CMD} apt install -y  \
    byacc                   \
    flex                    \
    g++                     \
    gcc                     \
    git                     \
    libncurses-dev          \
    make                    \
    python-dev              \
    python3-dev             \
    tcl8.6-dev              \
    texinfo                 \
    tk8.6-dev;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Clone binutils-gdb git repository
printMessage "Cloning binutils-gdb git repository into the ${BINUTILS_GDB_DIR_PATH} directory...";

git clone "${BINUTILS_GDB_GITHUB_URL}" "${BINUTILS_GDB_DIR_PATH}";
checkReturnCode "Failed to clone binutils-gdb git repository.";

printMessage "Successfully cloned binutils-gdb git repository.";

# Configure gdb
printMessage "Configuring gdb...";

mkdir -p "${BINUTILS_GDB_BUILD_DIR_PATH}" &&    \
cd "${BINUTILS_GDB_BUILD_DIR_PATH}" &&          \
CFLAGS="-g -O3"                                 \
"${BINUTILS_GDB_DIR_PATH}/configure"            \
    --prefix="${INSTALL_DIR_PATH}"              \
    --enable-tui                                \
    --enable-gdbtk                              \
    --with-curses                               \
    --with-python;
checkReturnCode "Failed to configure gdb.";

printMessage "Successfully configured gdb.";

# Build gdb
printMessage "Building gdb...";

make -j "${CPUS}";
checkReturnCode "Failed to build gdb.";

printMessage "Successfully built gdb.";

# Install gdb
printMessage "Installing gdb...";

${SUDO_CMD} make install -j "${CPUS}";
checkReturnCode "Failed to install gdb.";

printMessage "Successfully installed gdb.";

printMessage "Successfully set up gdb from source.";
