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
  echo "create a new project"
}

# shellcheck disable=SC2164
function execute() {
  local config_file="${PROJECT_DIR}/zen.json"
  [[ ! -f "${config_file}" ]] || error "Project config \"${config_file}\" already exists"
  mkdir -p "${PROJECT_DIR}"

  local starter_dir="${ZEN_HOME}/starters/x"
  echo "Creating a new project in \"${PROJECT_DIR}\""
  read -r -p "Application name (default: \"app\"): " app_name
  export app_name="${app_name:-app}"
  read -r -p "Version (default \"${ZEN_VERSION}\"): " app_version
  export app_version="${app_version:-${ZEN_VERSION}}"
  while [[ ! -d "${ZEN_HOME}/starters/${app_starter:-x}/" ]]; do
    read -r -p "Starter (default \"standard\"): " app_starter
    export app_starter="${app_starter:-standard}"
    starter_dir="${ZEN_HOME}/starters/${app_starter}/"
    [[ -d "${starter_dir}" ]] || log "${WARNING}" "${C_RED}Starter \"${app_starter}\" does not exist${C_DEFAULT}"
  done
  read -r -p "Port (default \"8080\"): " app_port
  export app_port="${app_port:-8080}"

  cd "${ZEN_HOME}/starters/${app_starter}/" >/dev/null
  find . -type d -exec mkdir -p "${PROJECT_DIR}/{}" \;
  while IFS= read -r file; do
    output="$(echo "${file}" | tr "@" "\$" | envsubst)"
    echo "Writing \"${PROJECT_DIR}/${output#./}\""
    envsubst <"${file}" >"${PROJECT_DIR}/${output}"
  done <<<"$(find ./ -type f)"
  cd - >/dev/null
  cp "${ZEN_HOME}/starters/${app_starter}/zen" "${PROJECT_DIR}/"
}
