#!/usr/bin/env bash
#
# Copyright 2018 The zensational authors.
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

set -euo pipefail

function get_time {
  date +%H:%M:%S.%N
}

function main {
  cd "$(dirname "$0")"

  local delay="${1:-}"
  local repeat=0
  [[ "${delay}" == "" ]] || repeat=2147483648

  for (( i=0; i<="${repeat}" ; i++ )); do
    local start_time="$(date +%s.%N)"
    echo "$(get_time) Starting Build..."
    echo "$(get_time) Compiling templates..."
    "${ZEN_HOME}/bin/zen.sh" clean cache
    "${ZEN_HOME}/bin/zen-template.sh" -f index.zt -o index.html

    local end_time="$(date +%s.%N)"
    local diff="$(echo print "${end_time}-${start_time}" | perl)"
    echo "$(get_time) Build successful in ${diff} sec"
    echo "########################################"
    sleep "${delay:-0}"
  done
}

main "$@"
