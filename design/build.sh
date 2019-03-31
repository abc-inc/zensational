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

set -euo pipefail

function read_css() {
  local css
  # shellcheck disable=SC2094
  while IFS='' read -r line; do
    if [[ "${line}" == "" || "${line}" == "/*"* || "${line}" == " *"* || "${line}" == "*/"* ]]; then
      continue
    elif [[ "${line}" == "@import"* ]]; then
      file="${line#*\'}"
      file="${file%\'*}"
      if [[ "$file" != */* ]]; then
        read_css "$(dirname "$1")/${file}"
        continue
      fi
    fi
    echo "${line}"
  done <"$1"
}

function get_time() {
  date +%H:%M:%S.%N
}

function main() {
  cd "$(dirname "$0")"

  local delay="${1:-}"
  local repeat=0
  [[ "${delay}" == "" ]] || repeat=2147483648

  for ((i = 0; i <= "${repeat}"; i++)); do
    local start_time
    start_time="$(date +%s.%N)"
    echo "$(get_time) Starting Build..."
    echo "$(get_time) Compressing CSS..."
    local css
    css="$(read_css "css/zensational.css")"
    css="${css//  / }"
    echo "${css}" >"css/zensational.all.css"

    css="${css//$'\n'/}"
    css="${css//  / }"
    css="${css//, /,}"
    css="${css//: /:}"
    css="${css// {/{}"
    css="${css//{ /{}"
    css="${css// \}/\}}"
    css="${css//;\}/\}}"
    echo -n "${css}" >"css/zensational.min.css"

    local end_time
    end_time="$(date +%s.%N)"
    local diff
    diff="$(echo print "${end_time}-${start_time}" | perl)"
    echo "$(get_time) Build successful in ${diff} sec"
    echo "########################################"
    sleep "${delay:-0}"
  done
}

main "$@"
