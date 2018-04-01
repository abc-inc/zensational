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

var z = require('../modules/base');

test('isArrayLike', function() {
  expect(z.isArrayLike('')).toBe(false);
  expect(z.isArrayLike(0)).toBe(false);
  expect(z.isArrayLike(false)).toBe(false);
  expect(z.isArrayLike(z)).toBe(false);
  expect(z.isArrayLike([])).toBe(true);
  expect(z.isArrayLike(null)).toBe(false);
  expect(z.isArrayLike(undefined)).toBe(false);
});

test('isDefAndNotNull', function() {
  expect(z.isDefAndNotNull(z)).toBe(true);
  expect(z.isDefAndNotNull(null)).toBe(false);
  expect(z.isDefAndNotNull(undefined)).toBe(false);
});

test('isFunction', function() {
  expect(z.isFunction(z.isFunction)).toBe(true);
  expect(z.isFunction(z.notDefined)).toBe(false);
  expect(z.isFunction(z)).toBe(false);
  expect(z.isFunction(null)).toBe(false);
  expect(z.isFunction(undefined)).toBe(false);
});

test('isObject', function() {
  expect(z.isObject('')).toBe(false);
  expect(z.isObject(0)).toBe(false);
  expect(z.isObject(false)).toBe(false);
  expect(z.isObject(z)).toBe(true);
  expect(z.isObject(z.isObject)).toBe(true);
  expect(z.isObject([])).toBe(true);
  expect(z.isObject(null)).toBe(false);
  expect(z.isObject(undefined)).toBe(false);
});
