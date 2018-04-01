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
  echo "create project distribution"
}

function usage {
  cat << EOF
$(basename "$0") dist TYPE...

TARGETS:
  docker  create Docker image
  zip     create zip archive
EOF
  exit 1
}

function execute {
  local targets="$@"
  [[ $# -gt 0 ]] || usage

  for target in ${targets}; do
    declare -F "dist_${target}" > /dev/null || usage
  done

  execute_task "build"

  for target in ${targets}; do
    "dist_${target}"
  done

  log_task
}

function dist_docker {
  log_task "dist:docker" "\\nCreating Docker image..."
  if ! docker --version 2> /dev/null; then
    error "Docker is not installed"
  fi

  local app_name
  app_name="$(parse_json '.name' "${PROJECT_DIR}/zen.json")"
  docker build -t "${app_name}" "${PROJECT_DIR}/"
}

function dist_zip {
  local app_name
  local app_version
  app_name="$(parse_json '.name' "${PROJECT_DIR}/zen.json")"
  app_version="$(parse_json ".version // \"$(date +%s)\"" "${PROJECT_DIR}/zen.json")"
  local zip_file="${PROJECT_DIR}/build/${app_name}-${app_version}.zip"

  log_task "dist:zip" "\\nCreating zip archive \"${zip_file}\"..."
  mkdir -p "$(dirname "${zip_file}")"
  zip "${zip_file}" "app"
}
