#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CPUS=$(nproc --all);
CURRENT_DIR_PATH="$(pwd)";
XERCES_CPP_INSTALL_DIR_PATH="/opt/xerces-c";
XERCES_CPP_LIB_NAME="xerces-c-3.2.2";
XERCES_CPP_LIB_DIR_PATH="${CURRENT_DIR_PATH}/${XERCES_CPP_LIB_NAME}";
XERCES_CPP_LIB_ARCHIVE_PATH="${CURRENT_DIR_PATH}/${XERCES_CPP_LIB_NAME}.tar.gz";
XERCES_CPP_LIB_ARCHIVE_URL="http://mirror.ox.ac.uk/sites/rsync.apache.org/xerces/c/3/sources/${XERCES_CPP_LIB_NAME}.tar.gz";
USERNAME=$(whoami);

XERCES_CPP_BUILD_DIR_PATH="${XERCES_CPP_LIB_DIR_PATH}/build";

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

printMessage "Setting up Xerces-C++ from source...";
printMessage "CPU(s): ${CPUS}";
printMessage "User: ${USERNAME}";

# Install dependencies
printMessage "Installing dependencies...";

${SUDO_CMD} apt update &&   \
${SUDO_CMD} apt install -y  \
    cmake                   \
    g++-multilib            \
    make                    \
    wget;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Download Xerces-C++ archive
printMessage "Downloading Xerces-C++ archive from ${XERCES_CPP_LIB_ARCHIVE_URL} to ${XERCES_CPP_LIB_ARCHIVE_PATH}...";

wget -O "${XERCES_CPP_LIB_ARCHIVE_PATH}" "${XERCES_CPP_LIB_ARCHIVE_URL}";
checkReturnCode "Failed to download Xerces-C++ archive.";

printMessage "Successfully downloaded Xerces-C++ archive.";

# Extract Xerces-C++ archive
printMessage "Extracting and then removing Xerces-C++ archive ${XERCES_CPP_LIB_ARCHIVE_PATH}...";

tar xvzf "${XERCES_CPP_LIB_ARCHIVE_PATH}" && \
rm -f "${XERCES_CPP_LIB_ARCHIVE_PATH}";
checkReturnCode "Failed to extract and then remove Xerces-C++ archive.";

printMessage "Successfully extracted and then removed Xerces-C++ archive.";

# Configure Xerces-C++
printMessage "Configuring Xerces-C++...";

mkdir -p "${XERCES_CPP_BUILD_DIR_PATH}" &&                  \
cd "${XERCES_CPP_BUILD_DIR_PATH}" &&                        \
CFLAGS=-O3 CXXFLAGS=-O3 cmake                               \
    -G "Unix Makefiles"                                     \
    -DCMAKE_INSTALL_PREFIX="${XERCES_CPP_INSTALL_DIR_PATH}" \
    -DCMAKE_BUILD_TYPE=Release                              \
    "${XERCES_CPP_LIB_DIR_PATH}";
checkReturnCode "Failed to configure Xerces-C++.";

printMessage "Successfully configured Xerces-C++.";

# Build Xerces-C++
printMessage "Building Xerces-C++...";

make -j "${CPUS}";
checkReturnCode "Failed to build Xerces-C++.";

printMessage "Successfully built Xerces-C++.";

# Install Xerces-C++
printMessage "Installing Xerces-C++ in directory ${XERCES_CPP_INSTALL_DIR_PATH}...";

make -j "${CPUS}" install;
checkReturnCode "Failed to install Xerces-C++.";

printMessage "Successfully installed Xerces-C++.";

printMessage "Successfully set up Xerces-C++ from source.";
