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

function execute_task() {
  local task="${1:-help}"
  local task_script="${ZEN_TASKS_DIR}/${task}.sh"

  if [[ " ${executed_tasks[*]} " == *" ${task} "* ]]; then
    log "${INFO}" "${C_CYAN}:${task}${C_DEFAULT} ${C_YELLOW}UP-TO-DATE${C_DEFAULT}"
    return
  fi

  if [[ ! -f "${task_script}" ]]; then
    execute_task "help"
    exit 1
  fi

  executed_tasks+=("${task}")
  shift || :
  # shellcheck disable=SC1090
  source "${task_script}"
  execute "$@"
}

function main() {
  PROJECT_DIR="${PWD}"
  executed_tasks=()

  ZEN_HOME="$(cd "$(dirname "$0")/../" && pwd)"
  export ZEN_HOME
  # shellcheck source=utils/utils.sh
  source "${ZEN_HOME}/bin/utils/utils.sh"
  # shellcheck source=../config/zen.config.sh
  source "${ZEN_HOME}/config/zen.config.sh"

  for lib in "${ZEN_HOME}"/lib/*; do
    # shellcheck disable=SC1090
    source "${lib}/$(basename "${lib}").sh"
  done

  while getopts ":d:hv" arg; do
    case "${arg}" in
      d) PROJECT_DIR="$(realpath "${OPTARG}")" ;;
      h)
        execute_task "help"
        exit
        ;;
      v)
        execute_task "version"
        exit
        ;;
      *)
        execute_task "help"
        exit 1
        ;;
    esac
  done
  shift $((OPTIND - 1))

  readonly PROJECT_DIR
  [[ -d "${PROJECT_DIR}" || "${1:-}" == "new" ]] || error "Directory \"${PROJECT_DIR}\" does not exist."

  execute_task "$@"
}

main "$@"
