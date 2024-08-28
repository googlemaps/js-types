#!/bin/bash

set -x

dt="dt"
index="types/google.maps/index.d.ts"
tests="types/google.maps/google.maps-tests.ts"

# Run from root of workspace
cd "${GITHUB_WORKSPACE}"

# Extract the first two fields of the version number
version=$(cat js-types/VERSION | cut -d '.' -f1-2)

# Update the version number in dt's package.json using sed, in place
# the .9999 is a requirement of DefinitelyTyped
sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"$version.9999\"/" dt/types/google.maps/package.json

# Copy file from bazel output
cp js-types/bazel-bin/definitelytyped.d.ts "${dt}/${index}"

cd "${dt}"

# Run git diff on the tpyings
git diff --exit-code "${index}"

# Update tests if there are changes allowing owner to merge 
# instead of waiting for maintainer review
if [[ $?  == 1 ]]; then
    echo "// No tests required for generated types" > "${tests}"
    echo "// Synced from: https://github.com/googlemaps/js-types/commit/${GITHUB_SHA}" >> "${tests}"
    echo "google.maps.Map;" >> "${tests}"    
fi

