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
  echo "download and install zensational"
}

function execute() {
  log_task
  mkdir -p "${ZEN_BIN_DIR}"
  setup_jq
  setup_websocketd
  log "${DEBUG}" "Making binaries executable..."
  chmod +x "${ZEN_BIN_DIR}"/*
}

function setup_jq() {
  if [[ ! -f "${ZEN_BIN_DIR}/jq" ]]; then
    log_task "setup:jq"
    log "${INFO}" "Downloading jq ${VERSION_JQ} to ${ZEN_BIN_DIR}/jq..."
    curl -s -L -o "${ZEN_BIN_DIR}/jq" "https://github.com/stedolan/jq/releases/download/jq-${VERSION_JQ}/jq-linux64"
  else
    log_task "setup:jq" " ${C_YELLOW}UP-TO-DATE${C_DEFAULT}"
    log "${INFO}" "$("${ZEN_BIN_DIR}/jq" --version) is already installed"
  fi
}

function setup_websocketd() {
  if [[ ! -f "${ZEN_BIN_DIR}/websocketd" ]]; then
    log_task "setup:websocketd"
    log "${INFO}" "Downloading websocketd ${VERSION_WEBSOCKETD} to ${ZEN_BIN_DIR}/websocketd..."
    curl -s -L -o "${ZEN_BIN_DIR}/websocketd.zip" "https://github.com/joewalnes/websocketd/releases/download/v${VERSION_WEBSOCKETD}/websocketd-${VERSION_WEBSOCKETD}-linux_amd64.zip"
    unzip -d "${ZEN_BIN_DIR}" "${ZEN_BIN_DIR}/websocketd.zip" "websocketd" >/dev/null
    rm -f "${ZEN_BIN_DIR}/websocketd.zip"
  else
    log_task "setup:websocketd" " ${C_YELLOW}UP-TO-DATE${C_DEFAULT}"
    local version
    version="$("${ZEN_BIN_DIR}/websocketd" --version)"
    log "${INFO}" "${version% --} is already installed."
  fi
}
