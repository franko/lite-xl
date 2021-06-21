#!/bin/bash
set -ex

meson subprojects download

compiler_flags="-DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_12,"
compiler_flags="${compiler_flags}-mmacosx-version-min=10.12,"
compiler_flags="${compiler_flags}-arch,arm64,"
compiler_flags="${compiler_flags}-arch,x86_64"

linker_flags="-mmacosx-version-min=10.12,"
linker_flags="${linker_flags}-arch,arm64,"
linker_flags="${linker_flags}-arch,x86_64"

meson setup \
  --prefix=${APPVEYOR_BUILD_FOLDER}/lite-xl.app \
  --bindir=Contents/MacOS \
  --buildtype=release \
  -D c_args="$compiler_flags" \
  -D c_link_args="$linker_flags" \
  -D cpp_args="$compiler_flags" \
  -D cpp_link_args="$linker_flags" \
  -D objc_args="$compiler_flags" \
  -D objc_link_args="$linker_flags" \
  build
# --cross-file=${APPVEYOR_BUILD_FOLDER}/dev-utils/meson-macos-arm64.ini \
# --cross-file=${APPVEYOR_BUILD_FOLDER}/dev-utils/meson-macos-x86_64.ini \
