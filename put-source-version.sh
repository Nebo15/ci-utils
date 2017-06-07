#!/bin/bash
# This script saves incremented version in a project source code.
set -e

echo "[I] Incrementing project version from '${PREVIOUS_VERSION}' to '${NEXT_VERSION}' in 'package.json'."
sed -i'' -e "s/\"version\": \"${PREVIOUS_VERSION}\"/\"version\": \"${NEXT_VERSION}\"/g" "${PROJECT_DIR}/package.json"

# Here you can modify other files (for eg. README.md) that contains version.
