#!/usr/bin/env bash

# Exit if any errors occur
set -e

# Get the current directory (/scripts/ directory)
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Traverse up to get to the root directory
SDK_DIR="$(dirname "$SCRIPTS_DIR")"
SAMPLE_DIR=sample
SDK_NAME=react-native-adjust

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

# Removing the old Android JAR file
echo -e "${GREEN}>>> Building the Android JAR file ${NC}"
cd ${SDK_DIR}
rm -rfv android/libs/*

# Building the Android JAR file
echo -e "${GREEN}>>> Building the Android JAR file ${NC}"
ext/android/build.sh

# Remove and unlink node module from sample project
echo -e "${GREEN}>>> Uninstall and unlink current module ${NC}"
cd ${SDK_DIR}/${SAMPLE_DIR}
rnpm uninstall ${SDK_NAME}

# Create a new directory with SDK_NAME
echo -e "${GREEN}>>> Create new directory in node_modules ${NC}"
mkdir node_modules/${SDK_NAME}

# Copy things to it
echo -e "${GREEN}>>> Copy modules to ${SAMPLE_DIR}/node_modules/${SDK_NAME} ${NC}"
cd ${SDK_DIR}
rsync -a . ${SAMPLE_DIR}/node_modules/${SDK_NAME} --exclude=sample --exclude=ext --exclude=scripts

# Establish link
echo -e "${GREEN}>>> Establish linkage to ${SDK_NAME} ${NC}"
cd ${SAMPLE_DIR}
rnpm link ${SDK_NAME}

echo -e "${GREEN}>>> Building & Running on Android ${NC}"
react-native run-android
