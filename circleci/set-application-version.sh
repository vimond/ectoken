#!/bin/bash

APPLICATION_VERSION=$(echo "$1" | xargs)

if [ -z "$APPLICATION_VERSION" ]; then
    echo "Missing first argument for the application version"
    exit 1
fi

mvn versions:set -DgenerateBackupPoms=false -DnewVersion="$APPLICATION_VERSION"
