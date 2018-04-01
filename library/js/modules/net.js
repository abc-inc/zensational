/*
 * Copyright 2018 The zensational authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

z.net = z.provide('net');

z.require('asserts');


/**
 * @param {String} url
 * @param {Function} listener
 */
z.net.get = function (url, listener) {
  this.send({'method': 'GET', 'url': url, 'async': true, 'listener': listener});
};

/**
 * @param {Object} params
 */
z.net.send = function (params) {
  z.asserts.assert(z.isDefAndNotNull(params['url']), '"url" must be defined');
  z.asserts.assert(z.isDefAndNotNull(params['listener']), '"listener" must be defined');

  if (z.isDefAndNotNull(window['fetch'])) {
    window.fetch(params['url'], params)
        .then(params['listener']);
  }

  var request = new XMLHttpRequest();
  request.open(
      params['method'] || 'GET',
      params['url'],
      !!params['async']);
  request.addEventListener('load', params['listener']);
  request.send(params['data']);
};
