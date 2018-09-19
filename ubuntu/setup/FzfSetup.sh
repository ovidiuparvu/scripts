#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CPUS=$(nproc --all);
FZF_GITHUB_URL="https://github.com/junegunn/fzf.git";
INSTALL_DIR_PATH="${HOME}/.fzf";
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

printMessage "Setting up fzf from source...";
printMessage "CPU(s): ${CPUS}";
printMessage "User: ${USERNAME}";

# Install dependencies
printMessage "Installing dependencies...";

${SUDO_CMD} apt update &&   \
${SUDO_CMD} apt install -y  \
    curl                    \
    git;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Clone fzf git repository
printMessage "Cloning fzf git repository into the ${INSTALL_DIR_PATH} directory...";

git clone "${FZF_GITHUB_URL}" "${INSTALL_DIR_PATH}";
checkReturnCode "Failed to clone fzf git repository.";

printMessage "Successfully cloned fzf git repository.";

# Install fzf
printMessage "Installing fzf...";

"${INSTALL_DIR_PATH}/install";
checkReturnCode "Failed to install fzf.";

printMessage "Successfully installed fzf.";

printMessage "Successfully set up fzf from source.";
