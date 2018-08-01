#!/bin/bash

# Implements the versioning logic foud in our gradle plugin
# https://github.com/vimond/VimondCommon/blob/5940b347849a643a6e1559475f77cff63fb120c4/buildSrc/src/main/groovy/com/vimond/common/build/VimondBuildSetupPlugin.groovy

readonly REGEX_IS_STRICT_SEMVER="^v?[0-9]+(\\.[0-9]+)*\$"
readonly REGEX_IS_SEMVER="^v?[0-9]+(\\.[0-9]+)*"
readonly BUILD_NUMBER="$CIRCLE_BUILD_NUM"

if [ -z "$BUILD_NUMBER" ]; then
    echo "CIRCLE_BUILD_NUM is not set"
    exit 1
fi

GIT_VERSION=`git describe --tags`

if [ $? -eq 1 ]; then
    echo "Failed to retrieve git version"
    exit 1
fi


APPLICATION_VERSION="${GIT_VERSION}"

IS_STRICT_SEMVER=false
IS_SEMVER=false

if [[ $GIT_VERSION =~ $REGEX_IS_STRICT_SEMVER ]]; then
    IS_STRICT_SEMVER=true
fi

if [[ $GIT_VERSION =~ $REGEX_IS_SEMVER ]]; then
    IS_SEMVER=true
fi

if $IS_SEMVER; then
    APPLICATION_VERSION=`echo "$GIT_VERSION" | sed 's/^v//g'`
fi

if ! $IS_STRICT_SEMVER; then
    APPLICATION_VERSION="${APPLICATION_VERSION}.b${BUILD_NUMBER}"
fi

echo "$APPLICATION_VERSION"
