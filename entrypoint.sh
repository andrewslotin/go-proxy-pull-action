#!/bin/sh

readonly TAG=${GITHUB_REF#refs/tags/*}
readonly VERSION=${TAG##*/}

PACKAGE=github.com/${GITHUB_REPOSITORY}
if [[ "$VERSION" != "$TAG" ]]; then
  PACKAGE=github.com/${GITHUB_REPOSITORY}/${TAG%"/$VERSION"}
fi

# if version > 1, then add the version scope
readonly MAJOR_VERSION="$(printf '%s' "$VERSION" | cut -d '.' -f 1 | sed 's/v//g')"
if [ $((10#${MAJOR_VERSION})) -gt 1 ]; then
  PACKAGE="$PACKAGE/v$MAJOR_VERSION"
fi

export GO111MODULE=on
export GOPROXY="$INPUT_GOPROXY"

mkdir dummy
cd dummy
go mod init dummy
go get "$PACKAGE@$VERSION"
