#!/bin/bash
set -e

# Prototypes the use of SAW toolchain  with a source Rust program.
#
# Expected to be run from within the context of the source file, e.g. ./sawrust.sh

# Assumes that SAW has already been built locally.
# Assumes that Rust has been installed, and is on a version of LLVM
# that is supported by SAW. As of initial checkin, 
# the "stable" version of "rustup" toolchain used LLVM 3.9.1
SOURCE_NAME="minimal_rust"
MINIMAL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUT_DIR="${MINIMAL_DIR}/out"


echo "Cleaning directories"
rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}"
cargo clean

echo "Building Rust program to bitcode"
RUSTFLAGS='--emit=llvm-bc -A unused_variables -A unused_assignments' cargo build
SOURCE_NAME_PATTERN="${SOURCE_NAME}*.bc"
COMPILED_BC="$(find ./target/debug/deps/ -name ${SOURCE_NAME_PATTERN} | xargs readlink -f)"
OUT_BC="${OUT_DIR}/${SOURCE_NAME}.bc"
cp "${COMPILED_BC}" "${OUT_BC}"

echo "Running the saw script"
../../bin/saw --verbose=4 compare_rust.saw
