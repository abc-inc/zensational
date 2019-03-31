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

function determine_color() {
  stty_settings="$(stty -g)"
  stty raw -echo min 0 time 0
  echo -en "\033]11;?\033\\" >/dev/tty
  if IFS=";" read -r -d "\\" color; then
    color="$(echo "${color,,}" | sed 's/^.*\;//;s/[^rgb:0-9a-f/]//g')"
  fi
  color="$(echo "${color##*:}" | sed -r 's/([0-9a-f]{2}){2}/\1/g' | tr "abcdef" "999999")"
  color="$((${color//\//+}))"
  echo "${color}"
  stty "${stty_settings}"
}

if ! (tty | grep -q "/dev/pt"); then
  # shellcheck source=color_plain.sh
  source "$(dirname "${BASH_SOURCE[0]}")/color_plain.sh"
elif [[ "$(determine_color)" -lt 128 ]]; then
  # shellcheck source=color_dark.sh
  source "$(dirname "${BASH_SOURCE[0]}")/color_dark.sh"
else
  # shellcheck source=color_light.sh
  source "$(dirname "${BASH_SOURCE[0]}")/color_light.sh"
fi
