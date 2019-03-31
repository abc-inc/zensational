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

function log() {
  if [[ "$1" -le ${LOG_LEVEL} ]]; then
    shift
    echo -e "$@"
  fi
}

function log_task() {
  local task="${1:-}"
  task="${task##/*}"
  shift || :
  [[ -n "${task}" ]] || task="$(basename -s .sh "${BASH_SOURCE[1]}")"
  log "${INFO}" "${C_CYAN}:${task}${C_DEFAULT}$*"
}

function error() {
  log "${ERROR}" "${C_RED}ERROR: $*${C_DEFAULT}" >&2
  exit 1
}

function parse_json() {
  [[ -f "$2" ]] || error "File \"$2\" does not exist."
  "${ZEN_BIN_DIR}/jq" -r "$1" <<<"$(<"$2")"
}
