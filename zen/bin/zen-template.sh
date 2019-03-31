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

function calc_checksum() {
  local checksum

  [[ -f "$1" ]] || return 1

  checksum="$("${ZEN_CHECKSUM_FUNCTION}" "$1")"
  checksum="${checksum%% *}"

  if [[ $# -gt 1 ]]; then
    shift
    local param_checksum
    param_checksum="_$(echo "$@" | "${ZEN_CHECKSUM_FUNCTION}")"
    checksum+="${param_checksum%% *}"
  fi

  echo "${checksum}"
}

function is_cacheable() {
  ! grep -qE '\$\([^(]' "$1" || [[ $# -gt 1 ]]
}

function resolve_cached_file() {
  local file="$1"
  local checksum="$2"
  echo "${ZEN_CACHES_DIR}/${ZEN_VERSION}/${checksum}/$(basename "${file}")"
}

function parse_template() {
  local inputFile="$1"
  local rc=0
  local result="#!/usr/bin/env bash
set -euo pipefail
ZEN_STOPWATCH_START=\"\$(date +%s%N)\"
"

  # shellcheck disable=SC2094
  while IFS='' read -r line || [[ -n "${line}" ]]; do
    local str="${line%$'\r'}"
    local cmd=""
    if [[ "${str}" == *\#* ]]; then
      # shellcheck disable=SC2086
      set -- ${str}
      cmd="$1"
    fi
    if [[ "${cmd}" == "#if" || "${cmd}" == "#elif" ]]; then
      str="${str/\#/}"
      str="${str//<=/ -le }"
      str="${str//>=/ -ge }"
      str="${str//</ -lt }"
      str="${str//>/ -gt }"
      str="${str/ [ / [[ }"
      str="${str/ ]/ ]]}"
      str="${str}; then"
    elif [[ "${cmd}" == "#else" ]]; then
      str="${str/\#/}"
    elif [[ "${cmd}" == "#endif" ]]; then
      str="${str/\#endif/fi}"
    elif [[ "${cmd}" == "#for" ]]; then
      str="${str/\#/}"
      str="$(echo "${str}" | sed -re "s/([0-9]+)\s*\.\.\s*([0-9]+)/{\1..\2}/g")"
      str="${str}; do"
    elif [[ "${cmd}" == "#endfor" || "${cmd}" == "done" ]]; then
      str="done"
    elif [[ "${cmd}" == "#import" ]]; then
      local file
      file="$(dirname "${inputFile}")/$2.zt"
      shift 2
      local start_time
      start_time="$(date +%s%N)"
      file="$(process_template "${file}" "$@")" || rc=$?
      local end_time
      end_time="$(date +%s%N)"
      echo "Processed  ${file} in $(((end_time - start_time) / 1000000)) ms" >&2
      if [[ "${rc}" -ne 0 ]]; then
        echo "${file}"
        return "${rc}"
      fi
      str="${file} $*"
    elif [[ "${cmd}" == "#var" ]]; then
      str="${str/\#var/export}"
    elif [[ "${cmd}" == "#val" ]]; then
      str="${str/\#val/readonly}"
    elif [[ "${cmd}" == "#const" ]]; then
      str="${str/\#const/readonly}"
    elif [[ "${cmd}" == "#continue" || "${cmd}" == "#break" ]]; then
      str="${cmd#\#}"
    else
      str="cat << EOF"$'\n'"${str}"$'\n'"EOF"
    fi
    result+="${str}
"
  done <"${inputFile}"

  result+="ZEN_STOPWATCH_END=\"\$(date +%s%N)\"
echo \"Executed   ${inputFile} in \$(((\${ZEN_STOPWATCH_END}-\${ZEN_STOPWATCH_START})/1000000)) ms\" >&2"

  echo "${result}" | tr "\\n" "\\r" | sed -e "s/\\rEOF\\rcat << EOF\\r/\\r/g" | tr "\\r" "\\n"
}

function process_template() {
  local template="$1"
  local checksum
  local cached_template
  local result
  local rc=0

  [[ -f "${template}" ]] || error "Template \"${template}\" does not exist."
  shift
  checksum="$(calc_checksum "${template}" "$@")"
  cached_template="$(resolve_cached_file "${template}" "${checksum}")"

  if (! is_cacheable "${template}" "$@") || [[ ! -f "${cached_template}" ]]; then
    mkdir -p "$(dirname "${cached_template}")"
    result="$(parse_template "${template}" "$@")" || rc=$?
    if [[ "${rc}" -ne 0 ]]; then
      echo "${result}"
      return "${rc}"
    fi
    echo "${result}" >"${cached_template}"
    chmod +x "${cached_template}"
  fi

  echo "${cached_template}"
}

function run_template() {
  local template="$1"
  local checksum
  local output
  local result
  local rc=0

  shift
  checksum="$(calc_checksum "${template}" "$@")"
  output="$(resolve_cached_file "${template}" "${checksum}")"

  if [[ ! -f "${output}" ]]; then
    result="$(process_template "${template}" "$@")" || rc=$?
    if [[ "${rc}" -ne 0 ]]; then
      echo "${result}"
      return "${rc}"
    fi
    "${result}" "$@" >"${output}.sh"
  else
    local imports
    imports="$(grep -F '#import' "${template}")"
    while IFS=$'\n' read -r import || [[ -n "${import}" ]]; do
      [[ -n "${import}" ]] || continue
      # shellcheck disable=SC2086
      set -- ${import}
      import="$2"
      shift 2
      result="$(process_template "$(dirname "${template}")/${import}.zt" "$@")" || rc=$?
      if [[ "${rc}" -ne 0 ]]; then
        echo "${result}"
        return "${rc}"
      fi
    done <<<"${imports}"

    echo "Running    ${template}" >&2
    "${output}" "$@" >"${output}.sh"
  fi

  echo "${output}.sh"
}

function usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTION...] [ARG...]
  -f, --file     template file
  -o, --output   output file (stdout if not set)

OPTIONS:
  -h, --help     display this help and exit
  -v, --version  output version information and exit
EOF
  exit 1
}

function main() {
  local rc=0
  local output="-"

  # shellcheck source=utils/utils.sh
  source "${ZEN_HOME}/bin/utils/utils.sh"
  # shellcheck source=../config/zen.config.sh
  source "${ZEN_HOME}/config/zen.config.sh"

  for lib in "${ZEN_HOME}"/lib/*; do
    # shellcheck disable=SC1090
    source "${lib}/$(basename "${lib}").sh"
  done

  while getopts ":f:o:" flag; do
    case "${flag}" in
      f) template="${OPTARG}" ;;
      o) output="${OPTARG}" ;;
      *) error "Unexpected option ${flag}" ;;
    esac
  done
  [[ -n "${template:-}" ]] || usage

  file="$(run_template "${template}")" || rc=$?
  if [[ "${rc}" -ne 0 ]]; then
    echo "${file}"
    exit "${rc}"
  fi
  if [[ "${output}" == "-" ]]; then
    cat "${file}"
  else
    cat "${file}" >"${output}"
  fi
}

main "$@"
