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

z.events = z.provide('events');

z.require('dom');


/**
 * @param {String|Element} element
 * @param {String|Array<String>} type
 * @param {Function} listener
 * @param {boolean?} opt_useCapture
 */
z.events.listen = function (element, type, listener, opt_useCapture) {
  /** @type {Element} */
  element = z.dom.getElementById(element);
  var types = (z.isArrayLike(type)) ? type : [type];
  for (var i = 0; i < types.length; i++) {
    element.addEventListener(type[i], listener, opt_useCapture);
  }
};
