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
  echo "start the web application"
}

function execute {
  execute_task "build"
  log_task

  local port
  local app_dir="${PROJECT_DIR}/app"
  port="$(parse_json ".port // 8080" "${PROJECT_DIR}/zen.json")"
  app_dir="${app_dir//\/\//\/}"
  mkdir -p "${app_dir}"

  if python --version 2> /dev/null; then
    run_python "${port:-8080}" "${app_dir}"
  else
    run_websocketd "${port:-8080}" "${app_dir}"
  fi
}

function run_websocketd {
  local port="${1:-8080}"
  local app_dir="$2"
  log "${INFO}" "Starting webserver at port ${port}..."
  "${ZEN_BIN_DIR}/websocketd" --port "${port}" --staticdir "${app_dir}"
}

function run_python {
  local port="${1:-8080}"
  local app_dir="$2"
  cd "${app_dir}" && python -m SimpleHTTPServer "${port}"
}
