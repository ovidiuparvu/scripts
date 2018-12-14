#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

CLANG_DIR_REL_PATH="clang";
COMPILER_RT_DIR_REL_PATH="compiler-rt";
CLANG_EXTRA_DIR_REL_PATH="extra";
CLANG_SVN_URL="http://llvm.org/svn/llvm-project/cfe/trunk";
CLANG_EXTRA_SVN_URL="http://llvm.org/svn/llvm-project/clang-tools-extra/trunk";
COMPILER_RT_SVN_URL="http://llvm.org/svn/llvm-project/compiler-rt/trunk";
CPUS=$(nproc --all);
CURRENT_DIR_PATH=$(pwd);
INSTALL_DIR_PATH="/usr/local";
LLVM_DIR_PATH="${CURRENT_DIR_PATH}/llvm";
LLVM_SVN_URL="http://llvm.org/svn/llvm-project/llvm/trunk";
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

printMessage "Setting up clang from source...";
printMessage "CPU(s): ${CPUS}";
printMessage "User: ${USERNAME}";

# Install dependencies
printMessage "Installing dependencies...";

${SUDO_CMD} apt update &&   \
${SUDO_CMD} apt install -y  \
    binutils                \
    cmake                   \
    g++                     \
    gcc                     \
    git                     \
    make                    \
    python2.7               \
    subversion              \
    zlib1g;
checkReturnCode "Failed to install dependencies.";

printMessage "Successfully installed dependencies.";

# Check out LLVM
printMessage "Checking out llvm into the ${LLVM_DIR_PATH} directory...";

svn co ${LLVM_SVN_URL} "${LLVM_DIR_PATH}";
checkReturnCode "Failed to check out llvm.";

printMessage "Successfully checked out llvm.";

# Check out Clang
printMessage "Checking out clang...";

cd "${LLVM_DIR_PATH}/tools" &&                  \
svn co ${CLANG_SVN_URL} "${CLANG_DIR_REL_PATH}";
checkReturnCode "Failed to check out clang.";

printMessage "Successfully checked out clang.";

# Check out extra Clang tools (optional) 
printMessage "Checking out extra clang tools...";

cd "${CLANG_DIR_REL_PATH}/tools" &&                         \
svn co ${CLANG_EXTRA_SVN_URL} "${CLANG_EXTRA_DIR_REL_PATH}";
checkReturnCode "Failed to check out extra clang tools.";

printMessage "Successfully checked out extra clang tools.";

# Check out Compiler-RT (optional)
printMessage "Checking out compiler-rt...";

cd "${LLVM_DIR_PATH}/projects" &&                           \
svn co ${COMPILER_RT_SVN_URL} "${COMPILER_RT_DIR_REL_PATH}";
checkReturnCode "Failed to check out compiler-rt.";

printMessage "Successfully checked out compiler-rt.";

# Build LLVM and Clang
printMessage "Building llvm and clang...";

cd "${LLVM_DIR_PATH}" &&                            \
rm -rf build &&                                     \
mkdir build &&                                      \
cd build &&                                         \
cmake                                               \
    -G "Unix Makefiles"                             \
    -DCMAKE_BUILD_TYPE="Release"                    \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR_PATH}"    \
    -DLLVM_TARGETS_TO_BUILD="all"                   \
    -DLLVM_BUILD_TOOLS="ON"                         \
    -DLLVM_INCLUDE_TOOLS="ON"                       \
    -DLLVM_BUILD_EXAMPLES="OFF"                     \
    -DLLVM_INCLUDE_EXAMPLES="OFF"                   \
    -DLLVM_BUILD_TESTS="OFF"                        \
    -DLLVM_INCLUDE_TESTS="OFF"                      \
    -DLLVM_INCLUDE_BENCHMARKS="OFF"                 \
    -DLLVM_APPEND_VC_REV="ON"                       \
    -DLLVM_ENABLE_THREADS="ON"                      \
    -DLLVM_ENABLE_LTO="Full"                        \
    -DLLVM_USE_LINKER="gold"                        \
    -DLLVM_PARALLEL_COMPILE_JOBS="${CPUS}"          \
    -DLLVM_PARALLEL_LINK_JOBS="${CPUS}"             \
    .. &&                                           \
make -j "${CPUS}";
checkReturnCode "Failed to build llvm and clang.";

printMessage "Successfully built llvm and clang.";

# Install clang
printMessage "Installing clang...";

${SUDO_CMD} make install;
checkReturnCode "Failed to install clang.";

printMessage "Successfully installed clang.";

printMessage "Successfully set up clang from source.";
