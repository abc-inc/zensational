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

  local zen_js="js/zen.min.js"
  local delay="${1:-}"
  local repeat=0
  [[ "${delay}" == "" ]] || repeat=2147483648

  for (( i=0; i<="${repeat}" ; i++ )); do
    local start_time="$(date +%s.%N)"
    echo "$(get_time) Starting Build..."
    echo "$(get_time) Compiling JavaScript..."
    head -n 15 "js/modules/base.js" > "${zen_js}"
    for module in base asserts string dom events net components; do
      local content="$(< "js/modules/${module}.js")"
      content="$(echo "${content}" | sed -r '/\/\*.+\*\//d; /\/\*/,/\*\//d')"
      content="$(echo "${content}" | sed -r "s/\s+([&|!=,;:(){}?+\-\*/])\s*/\1/g")"
      content="$(echo "${content}" | sed -r "s/\s*([&|!=,;:(){}?+\-\*/])\s+/\1/g")"
      content="${content//  /}"
      content="${content//$'\n'}"
      echo -n "${content}" >> "${zen_js}"
    done

    local end_time="$(date +%s.%N)"
    local diff="$(echo print "${end_time}-${start_time}" | perl)"
    echo "$(get_time) Build successful in ${diff} sec"
    echo "########################################"
    sleep "${delay:-0}"
  done
}

main "$@"
