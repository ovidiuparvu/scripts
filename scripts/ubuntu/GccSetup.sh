#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CPUS=$(nproc --all);
CURRENT_PATH=$(pwd);
GCC_DIR_PATH="${CURRENT_PATH}/gcc";
GCC_BUILD_DIR_PATH="${GCC_DIR_PATH}/build";
GCC_SRC_DIR_PATH="${GCC_DIR_PATH}/source";
GCC_BASE_VER_FILE_PATH="${GCC_SRC_DIR_PATH}/gcc/BASE-VER";
GCC_SVN_URL="svn://gcc.gnu.org/svn/gcc/trunk";
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

printMessage "Setting up gcc from source...";
printMessage "CPU(s): ${CPUS}";
printMessage "User: ${USERNAME}";

# Install dependencies
printMessage "Installing dependencies...";

${SUDO_CMD} apt update &&   \
${SUDO_CMD} apt install -y  \
    binutils                \
    curl                    \
    dejagnu                 \
    expect                  \
    flex                    \
    g++                     \
    g++-multilib            \
    gcc                     \
    gcc-multilib            \
    gzip                    \
    make                    \
    perl                    \
    subversion              \
    tar                     \
    tcl;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Check out gcc
printMessage "Checking out gcc into the ${GCC_SRC_DIR_PATH} directory...";

svn co ${GCC_SVN_URL} "${GCC_SRC_DIR_PATH}";
checkReturnCode "Failed to check out gcc.";

printMessage "Successfully checked out gcc.";

# Download prerequisites
printMessage "Downloading prerequisites...";

cd "${GCC_SRC_DIR_PATH}" &&         \
./contrib/download_prerequisites;
checkReturnCode "Failed to download prerequisites.";

printMessage "Successfully downloaded prerequisites.";

# Get gcc base version
printMessage "Retrieving gcc base version...";

gccBaseVersion=$(head -n1 <"${GCC_BASE_VER_FILE_PATH}");
checkReturnCode "Failed to retrieve gcc base version.";

printMessage "Successfully retrieved gcc base version: ${gccBaseVersion}.";

# Configure gcc
printMessage "Configuring gcc...";

rm -rf "${GCC_BUILD_DIR_PATH}" &&               \
mkdir -p "${GCC_BUILD_DIR_PATH}" &&             \
cd "${GCC_BUILD_DIR_PATH}" &&                   \
"${GCC_SRC_DIR_PATH}/configure"                 \
    --prefix="${INSTALL_DIR_PATH}"              \
    --program-suffix="${gccBaseVersion}"        \
    --with-local-prefix="${INSTALL_DIR_PATH}"   \
    --enable-multiarch                          \
    --enable-multilib                           \
    --enable-threads                            \
    --enable-version-specific-runtime-libs      \
    --enable-targets="all"                      \
    --enable-lto;
checkReturnCode "Failed to configure gcc.";

printMessage "Successfully configured gcc.";

# Build gcc
printMessage "Building gcc...";

make -j "${CPUS}";
checkReturnCode "Failed to build gcc.";

printMessage "Successfully built gcc.";

# Test gcc
printMessage "Testing gcc and g++...";

make -j "${CPUS}" check-c &&    \
make -j "${CPUS}" check-c++;
checkReturnCode "Failed to successfully run gcc and g++ tests.";

printMessage "Successfully tested gcc and g++.";

# Install gcc
printMessage "Installing gcc...";

${SUDO_CMD} make install;
checkReturnCode "Failed to install gcc.";

printMessage "Successfully installed gcc.";

printMessage "Successfully set up gcc from source.";
