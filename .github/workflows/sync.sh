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
types="types/google-maps-web/index.d.ts"

rm -rf DefinitelyTyped
gh repo fork DefinitelyTyped/DefinitelyTyped --clone=true
mkdir -p DefinitelyTyped/types/google-maps-web
cp bazel-bin/definitelytyped.d.ts "DefinitelyTyped/${types}"
cd DefinitelyTyped
git switch -c chore/sync-google-maps-web
git reset --hard upstream/master

git add "${types}"
git commit -am 'chore: sync google-maps-web'
# gh pr create --title 'chore: sync google-maps-web' --body 'This is a automatic pull request to update the google-maps-web types.' -w
