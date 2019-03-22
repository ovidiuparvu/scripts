#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CPUS=$(nproc --all);
CURRENT_DIR_PATH="$(pwd)";
RR_DIR_PATH="${CURRENT_DIR_PATH}/rr";
RR_GITHUB_URL="https://github.com/mozilla/rr.git";
USERNAME=$(whoami);

RR_BUILD_DIR_PATH="${RR_DIR_PATH}/build";

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

printMessage "Setting up rr from source...";
printMessage "CPU(s): ${CPUS}";
printMessage "User: ${USERNAME}";

# Install dependencies
printMessage "Installing dependencies...";

${SUDO_CMD} apt update &&   \
${SUDO_CMD} apt install -y  \
    capnproto               \
    ccache                  \
    cmake                   \
    coreutils               \
    g++-multilib            \
    gdb                     \
    git                     \
    libcapnp-dev            \
    make                    \
    manpages-dev            \
    ninja-build             \
    pkg-config              \
    python-pexpect          \
    python3-pexpect;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Clone rr git repository
printMessage "Cloning rr git repository...";

rm -rf "${RR_DIR_PATH}" &&                                          \
git clone --recurse-submodules "${RR_GITHUB_URL}" "${RR_DIR_PATH}";
checkReturnCode "Failed to clone rr git repository.";

printMessage "Successfully cloned rr git repository.";

# Create rr build directory
printMessage "Creating rr build directory ${RR_BUILD_DIR_PATH}...";

mkdir -p "${RR_BUILD_DIR_PATH}" && \
cd "${RR_BUILD_DIR_PATH}";
checkReturnCode "Failed to create rr build directory.";

printMessage "Successfully created rr build directory.";

# Configure rr
printMessage "Configuring rr...";

cd "${RR_BUILD_DIR_PATH}" &&    \
cmake                           \
    -DCMAKE_BUILD_TYPE=Release  \
    "${RR_DIR_PATH}";
checkReturnCode "Failed to configure rr.";

printMessage "Successfully configured rr.";

# Build rr
printMessage "Building rr...";

make -j "${CPUS}";
checkReturnCode "Failed to build rr.";

printMessage "Successfully built rr.";

# Install rr
printMessage "Installing rr...";

${SUDO_CMD} make install;
checkReturnCode "Failed to install rr.";

printMessage "Successfully installed rr.";

printMessage "Successfully set up rr from source.";
