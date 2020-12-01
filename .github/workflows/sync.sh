# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

src="$(pwd)/bazel-bin/definitelytyped.d.ts"
dest="types/google-maps-web/index.d.ts"
branch="chore/sync-google-maps-web"

pushd $(mktemp -d)

# Setup git
git clone git@github.com:DefinitelyTyped/DefinitelyTyped.git .
git remote add fork git@github.com:googlemaps/DefinitelyTyped.git

# update default branch of fork
git push fork -f

# Get a branch
git checkout -b "${branch}"

# Make changes
mkdir -p $(dirname "${dest}")
cp "${src}" "${dest}"

# Commit and push to fork
git add "${dest}"
git commit -am 'chore: sync google-maps-web'
git push fork -f

# Open pull request
gh pr create --title 'chore: sync google-maps-web' \
  --body 'This is a automatic pull request to update the google-maps-web dest.' \
  --head "googlemaps:${branch}"

popd
