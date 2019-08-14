#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CPUS=$(nproc --all);
USERNAME=$(whoami);
YOU_COMPLETE_ME_DIR_PATH="${HOME}/.vim/plugged/YouCompleteMe";
YOU_COMPLETE_ME_GITHUB_URL="https://github.com/ycm-core/YouCompleteMe.git";
YOU_COMPLETE_ME_INSTALL_FILE_PATH="${YOU_COMPLETE_ME_DIR_PATH}/install.py";

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

printMessage "Setting up YouCompleteMe from source...";
printMessage "CPU(s): ${CPUS}";
printMessage "User: ${USERNAME}";

# Install dependencies
printMessage "Installing dependencies...";

${SUDO_CMD} apt update &&   \
${SUDO_CMD} apt install -y  \
    build-essential         \
    cmake                   \
    git                     \
    python3-dev;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Clone YouCompleteMe git repository
printMessage "Cloning YouCompleteMe git repository into the ${YOU_COMPLETE_ME_DIR_PATH} directory...";

git clone --recurse-submodules -j "${CPUS}" "${YOU_COMPLETE_ME_GITHUB_URL}" "${YOU_COMPLETE_ME_DIR_PATH}";
checkReturnCode "Failed to clone YouCompleteMe git repository.";

printMessage "Successfully cloned YouCompleteMe git repository.";

# Install YouCompleteMe
printMessage "Installing YouCompleteMe...";

cd "${YOU_COMPLETE_ME_DIR_PATH}" &&             \
python3 "${YOU_COMPLETE_ME_INSTALL_FILE_PATH}"  \
    --clangd-completer                          \
    --java-completer;
checkReturnCode "Failed to install YouCompleteMe.";

printMessage "Successfully installed YouCompleteMe.";

printMessage "Successfully set up YouCompleteMe from source.";
