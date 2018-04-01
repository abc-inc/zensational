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

'use strict';

window.z = {};


/**
 * @param {String} module
 * @returns {Object}
 */
z.provide = function (module) {
  return z.isDefAndNotNull(z[module])
      ? z[module]
      : (z[module] = {});

};

/**
 * @param {String} module
 */
z.require = function (module) {
  if (z.isDefAndNotNull(z[module])) {
    return;
  }

  var request = new XMLHttpRequest();
  request.open("GET", "/js/" + module.replace('.', '/') + ".js", false);
  request.addEventListener('load', function (event) {
    var script = document.createElement('script');
    script.text = request.responseText;
    document.body.appendChild(script);
  });
  request.send();
};

/**
 * @param {*} val
 * @returns {boolean}
 */
z.isArrayLike = function (val) {
  return z.isObject(val) && z.isDefAndNotNull(val['length']);
};

/**
 * @param {*} val
 * @returns {boolean}
 */
z.isDefAndNotNull = function (val) {
  return val != null;
};

/**
 * @param {*} val
 * @returns {boolean}
 */
z.isFunction = function (val) {
  var className = Object.prototype.toString.call(/** @type {Object} */ (val));
  if (className === '[object Function]') {
    return true;
  } else if (z.isDefAndNotNull(val)
      && typeof val.call !== 'undefined'
      && typeof val.propertyIsEnumerable !== 'undefined'
      && !val.propertyIsEnumerable('call')) {
    return true;
  }
  return false;
};

/**
 * @param {*} val
 * @returns {boolean}
 */
z.isObject = function (val) {
  var type = typeof val;
  return type === "object" && val != null || type === "function";
};

/**
 * @returns {number}
 */
z.getCurrentTimestamp = function () {
  return +new Date();
};


if (typeof module !== 'undefined' && z.isDefAndNotNull(module['exports'])) {
  module['exports'] = z;
}
