#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CPUS=$(nproc --all);
CURRENT_DIR_PATH="$(pwd)";
GOOGLE_BENCHMARK_DIR_PATH="${CURRENT_DIR_PATH}/benchmark";
GOOGLE_BENCHMARK_GITHUB_URL="https://github.com/google/benchmark.git";
GOOGLE_BENCHMARK_INSTALL_DIR_PATH="${GOOGLE_BENCHMARK_DIR_PATH}/install";
USERNAME=$(whoami);

GOOGLE_BENCHMARK_BUILD_DIR_PATH="${GOOGLE_BENCHMARK_DIR_PATH}/build";

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

printMessage "Setting up google benchmark from source...";
printMessage "CPU(s): ${CPUS}";
printMessage "User: ${USERNAME}";

# Install dependencies
printMessage "Installing dependencies...";

${SUDO_CMD} apt update &&   \
${SUDO_CMD} apt install -y  \
    cmake                   \
    g++                     \
    gcc                     \
    git                     \
    make;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Clone google benchmark git repository
printMessage "Cloning google benchmark git repository...";

rm -rf "${GOOGLE_BENCHMARK_DIR_PATH}" &&                                                        \
git clone --recurse-submodules "${GOOGLE_BENCHMARK_GITHUB_URL}" "${GOOGLE_BENCHMARK_DIR_PATH}";
checkReturnCode "Failed to clone google benchmark git repository.";

printMessage "Successfully cloned google benchmark git repository.";

# Create google benchmark build directory
printMessage "Creating google benchmark build directory ${GOOGLE_BENCHMARK_BUILD_DIR_PATH}...";

mkdir -p "${GOOGLE_BENCHMARK_BUILD_DIR_PATH}" && \
cd "${GOOGLE_BENCHMARK_BUILD_DIR_PATH}";
checkReturnCode "Failed to create google benchmark build directory.";

printMessage "Successfully created google benchmark build directory.";

# Configure google benchmark
printMessage "Configuring google benchmark...";

cd "${GOOGLE_BENCHMARK_BUILD_DIR_PATH}" &&                          \
cmake                                                               \
    -DCMAKE_INSTALL_PREFIX="${GOOGLE_BENCHMARK_INSTALL_DIR_PATH}"   \
    -DCMAKE_BUILD_TYPE=Release                                      \
    -DBENCHMARK_DOWNLOAD_DEPENDENCIES=ON                            \
    "${GOOGLE_BENCHMARK_DIR_PATH}";
checkReturnCode "Failed to configure google benchmark.";

printMessage "Successfully configured google benchmark.";

# Build google benchmark
printMessage "Building google benchmark...";

make -j "${CPUS}";
checkReturnCode "Failed to build google benchmark.";

printMessage "Successfully built google benchmark.";

# Install google benchmark
printMessage "Installing google benchmark...";

mkdir -p "${GOOGLE_BENCHMARK_INSTALL_DIR_PATH}" &&  \
make install;
checkReturnCode "Failed to install google benchmark.";

printMessage "Successfully installed google benchmark.";

printMessage "Successfully set up google benchmark from source.";
