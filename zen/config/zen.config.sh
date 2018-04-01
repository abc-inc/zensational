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

readonly ERROR=0
readonly WARNING=1
readonly INFO=2
readonly DEBUG=3


export LOG_LEVEL="${INFO}"

export VERSION_JQ="1.5"
export VERSION_WEBSOCKETD="0.3.0"
export ZEN_VERSION="1.4"

export DOWNLOAD_URL="http://zensational.io/downloads/${ZEN_VERSION}/zensational-${ZEN_VERSION}.zip"
export ZEN_CHECKSUM_FUNCTION="sha1sum"

[[ -n "${ZEN_USER_HOME:+x}" ]] || export ZEN_USER_HOME="${HOME}/.zensational"
readonly ZEN_USER_HOME

export ZEN_CACHES_DIR="${ZEN_USER_HOME}/caches"
export ZEN_DISTS_DIR="${ZEN_USER_HOME}/dists"

export ZEN_BIN_DIR="${ZEN_HOME}/bin/${OSTYPE:-linux-gnu}"
export ZEN_MODULES_DIR="${ZEN_HOME}/js/modules"
export ZEN_TASKS_DIR="${ZEN_HOME}/tasks"
