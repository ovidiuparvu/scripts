#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

SHELLCHECK_DIR_REL_PATH="shellcheck";
SHELLCHECK_GITHUB_URL="https://github.com/koalaman/shellcheck.git";
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

printMessage "Setting up shellcheck from source...";
printMessage "User: ${USERNAME}";

# Install dependencies
printMessage "Installing dependencies...";

${SUDO_CMD} apt update &&   \
${SUDO_CMD} apt install -y  \
    cabal-install           \
    git;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Update the cabal dependency list
printMessage "Updating the cabal dependency list...";

cabal update;
checkReturnCode "Failed to update the cabal dependency list.";

printMessage "Successfully updated the cabal dependency list.";

# Clone the shellcheck repository
printMessage "Cloning the shellcheck repository...";

rm -rf "${SHELLCHECK_DIR_REL_PATH}" &&                          \
git clone ${SHELLCHECK_GITHUB_URL} "${SHELLCHECK_DIR_REL_PATH}";
checkReturnCode "Failed to clone the shellcheck repository.";

printMessage "Successfully cloned the shellcheck repository.";

# Install shellcheck
printMessage "Installing shellcheck...";

cd "${SHELLCHECK_DIR_REL_PATH}" && \
cabal install;
checkReturnCode "Failed to install shellcheck.";

printMessage "Successfully installed shellcheck.";

printMessage "Successfully set up shellcheck from source.";
