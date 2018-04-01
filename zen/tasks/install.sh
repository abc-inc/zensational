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
  echo "install the dependencies"
}

function execute {
  local modules
  local imported_modules=("")
  local zen_js="${PROJECT_DIR}/app/js/zen.js"
  local zen_json="${PROJECT_DIR}/zen.json"

  [[ -f "${zen_json}" ]] || error "File \"${zen_json}\" does not exist."
  if [[ "${zen_js}" -nt "${zen_json}" ]]; then
    log_task "${BASH_SOURCE[0]}" " ${C_YELLOW}UP-TO-DATE${C_DEFAULT}"
    return 0
  fi

  modules="$(parse_json ".modules | join(\" \")" "${zen_json}")"
  modules="${modules%%[$'\r\n']}"

  mkdir -p "${PROJECT_DIR}/app/js"
  : > "${zen_js}"
  import_module "base" "${zen_js}"
  for module in ${modules}; do
    import_module "${module}" "${zen_js}"
  done

  log_task
}

function import_module {
  if [[ " ${imported_modules[@]} " == *" $1 "* ]]; then
    log "${INFO}" "${C_YELLOW}module \"$1\" already imported${C_DEFAULT}"
    return
  fi
  log_task "install:import" " \"$1\""
  imported_modules+=("$1")

  if [[ -f "${ZEN_MODULES_DIR}/${1}.js" ]]; then
    local dependencies="$(cat "${ZEN_MODULES_DIR}/${1}.js" | grep "z.require(" | sed -re "s/.*z\.require\([\"'](.+)[\"']\).+/\1/g")"
    for dependency in ${dependencies}; do
      if [[ " ${imported_modules[@]} " =~ " ${dependency} " ]]; then
        log "${DEBUG}" "skipping already imported module \"${dependency}\""
      else
        log "${INFO}" "module \"$1\" requires \"${dependency}\""
        import_module "${dependency}" "$2"
      fi
    done
    cat "${ZEN_MODULES_DIR}/${1}.js" >> "$2"
  else
    error "Can't find module \"${1}\" (${ZEN_MODULES_DIR}/${1}.js)."
  fi
}
