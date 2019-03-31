#!/usr/bin/env bash
#
# Copyright 2019 The zensational authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

function info() {
  echo "clean the output"
}

function usage() {
  cat <<EOF
$(basename "$0") TARGET...

TARGETS:
  app    delete the webapp output
  cache  purge the template cache
EOF
  exit 1
}

function execute() {
  local targets="$*"
  [[ $# -gt 0 ]] || usage

  for target in ${targets}; do
    declare -F "clean_${target}" >/dev/null || usage
  done

  log_task

  for target in ${targets}; do
    "clean_${target}"
  done
}

function clean_app() {
  log_task "clean:app" "\\nCleaning webapp output..."
  rm -f "${PROJECT_DIR}/app/js/zen.js"
}

function clean_cache() {
  local dir="${ZEN_CACHES_DIR}/${ZEN_VERSION}"
  log_task "clean:cache" "\\nPurging cache \"${dir}\"..."
  rm -rf "${dir}"
}
