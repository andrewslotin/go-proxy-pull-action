#!/bin/sh

readonly TAG=${GITHUB_REF#refs/tags/*}
readonly VERSION=${TAG##*/}

PACKAGE=github.com/${GITHUB_REPOSITORY}
if [[ "$VERSION" != "$TAG" ]]; then
  PACKAGE=github.com/${GITHUB_REPOSITORY}/${TAG%"/$VERSION"}
fi

export GO111MODULE=on
export GOPROXY="$INPUT_GOPROXY"

go get "$PACKAGE@$VERSION"
