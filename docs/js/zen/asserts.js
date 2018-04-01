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

z.asserts = z.provide('asserts');


/**
 * @param {String} message
 * @constructor
 */
z.asserts.AssertionError = function (message) {
  this.message_ = message;
};

/**
 * @returns {String}
 */
z.asserts.AssertionError.prototype.getMessage = function () {
  return this.message_;
};

/**
 * @param {Function|boolean} cond
 * @param {String} message
 */
z.asserts.assert = function (cond, message) {
  if (z.isFunction(cond)) {
    if (!cond()) {
      throw new z.asserts.AssertionError(message);
    }
  } else if (!cond) {
    throw new z.asserts.AssertionError(message);
  }
};
