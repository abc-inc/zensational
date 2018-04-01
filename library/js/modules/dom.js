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

z.dom = z.provide('dom');


/**
 * @param {*} obj
 * @returns {boolean}
 */
z.dom.isElement = function (obj) {
  return z.isObject(obj) && obj.nodeType === 1;
};

/**
 * @param {String|Element} element
 * @returns {Node}
 */
z.dom.getElementByClass = function (element) {
  return z.dom.isElement(element)
      ? element
      : document.getElementsByClassName(String(element)).item(0);
};

/**
 * @param {String|Element} element
 * @returns {Element}
 */
z.dom.getElementById = function (element) {
  return z.dom.isElement(element)
      ? element
      : document.getElementById(String(element));
};

/**
 * @param {String|Element} element
 * @param {String|Element} element
 * @returns {Element}
 */
z.dom.appendNode = function (element, child) {
  /** @type {Element} */
  element = z.dom.getElementById(element);
  z.dom.isElement(child)
      ? (element.appendChild(child))
      : (element.innerHTML += child);
  return element;
};

/**
 * @param {String|Element} element
 * @param {Element} newElement
 */
z.dom.replaceNode = function (element, newElement) {
  z.dom.getElementById(element).replaceWith(newElement);
};

/**
 * @param {String|Element} element
 */
z.dom.removeChildren = function (element) {
  element = z.dom.getElementById(element);
  while (z.isDefAndNotNull(element.firstChild)) {
    element.removeChild(element.firstChild);
  }
};

/**
 * @param {String|Element} element
 * @param {String} tagName
 * @returns {Element|*}
 */
z.dom.getParent = function (element, tagName) {
  tagName = tagName.toUpperCase();
  element = z.dom.getElementById(element);
  while (z.isDefAndNotNull(element) && element.tagName !== tagName) {
    element = element.parentNode;
  }
  return element;
};
