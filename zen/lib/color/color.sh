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

function determine_color {
  echo -en "\033]11;?\033\\" > /dev/tty
  if IFS=';' read -r -d '\' color; then
    color="$(echo "${color,,}" | sed 's/^.*\;//;s/[^rgb:0-9a-f/]//g')"
  fi
  color="$(echo "${color##*:}" | tr "abcdef" "999999")"
  color="$(( ${color//\//+} ))"
  echo "${color}"
}

if ! (tty | grep -q "pty"); then
  source "$(dirname "${BASH_SOURCE[0]}")/color_plain.sh"
elif [[ "$(determine_color)" == "0" ]]; then
  source "$(dirname "${BASH_SOURCE[0]}")/color_dark.sh"
else
  source "$(dirname "${BASH_SOURCE[0]}")/color_light.sh"
fi
