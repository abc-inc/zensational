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

function info {
  echo "display this help"
}

function execute {
  log_task
  cat << EOF
Usage: $(basename "$0") [OPTION...] <task> [ARG...]

TASKS:
EOF

  for task in "${ZEN_TASKS_DIR}"/*.sh; do
    get_info "${task}"
  done

  cat << EOF

OPTIONS:
  -d, --directory  project directory (default "${PWD}")
  -h, --help       display this help and exit
  -v, --version    output version information and exit
EOF
}

function get_info {
  unset info
  # shellcheck disable=SC1090
  source "$1"
  printf "%-16s $(info 2> /dev/null || echo "")\\n" "$(basename "${1%.sh}")"
}
