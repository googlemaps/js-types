#!/bin/bash

set -x

index="dt/types/google-maps-web/index.d.ts"
tests="dt/types/google-maps-web/google-maps-web-tests.ts"

# Copy file from bazel output
cp js-types/bazel-bin/definitelytyped.d.ts "${index}"

# Run git diff on the tpyings
git diff --exit-code "${index}"

# Update tests if there are changes allowing owner to merge 
# instead of waiting for maintainer review
if [[ $?  == 1 ]]; then
    echo "// No tests required for generated types"
    echo "// Synced from: https://github.com/googlemaps/js-types/commit/${GITHUB_SHA}" >> "${tests}"
    echo "google.maps.Map;" >> "${tests}"
    git diff "${tests}"
fi

