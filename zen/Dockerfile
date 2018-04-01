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

FROM debian:9.4-slim

ARG APP_PORT
ARG ZEN_USER

ENV OSTYPE=linux-gnu
ENV ZEN_VERSION=1.4
ENV ZEN_USER_HOME="/home/${ZEN_USER:-zen}/.zensational"
ENV ZEN_HOME="${ZEN_USER_HOME}/dists/${ZEN_VERSION}"

RUN apt-get update \
 && apt-get install -y curl jq \
 && rm -rf /var/lib/apt/lists/* \
 && curl -s -L -O https://github.com/joewalnes/websocketd/releases/download/v0.3.0/websocketd-0.3.0_amd64.deb \
 && dpkg -i websocketd-0.3.0_amd64.deb \
 && rm -f websocketd-0.3.0_amd64.deb \
 && groupadd -r zen \
 && useradd --no-log-init -r -g zen "${ZEN_USER:-zen}"

USER "${ZEN_USER:-zen}"
WORKDIR /var/www/
EXPOSE ${APP_PORT:-8080}
CMD ["/var/www/zen", "run"]

COPY . "${ZEN_HOME}/"
