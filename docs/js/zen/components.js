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

z.provide('components');

z.require('dom');
z.require('string');


/**
 * @param {String} leftTitle
 * @param {String} rightTitle
 * @constructor
 */
z.components.NavBar = function (leftTitle, rightTitle) {
  this.leftTitle_ = leftTitle;
  this.rightTitle_ = rightTitle;
  this.uid_ = z.string.getRandomString();
};

/**
 * @param {String|Element} element
 */
z.components.NavBar.prototype.render = function (element) {
  if (z.isDefAndNotNull(z.dom.getElementById(this.uid_))) {
    return;
  }

  element = z.dom.getElementById(element);
  z.dom.appendNode(element,
      '<div id="' + this.uid_ + '" class="z-navbar">' +
      this.renderButton_('left', this.leftTitle_, null) +
      this.renderButton_('right', this.rightTitle_, null) +
      '</div>');
};

/**
 * @param {{text: String, link: String}} leftContent
 * @param {{text: String, link: String}} rightContent
 */
z.components.NavBar.prototype.update = function (leftContent, rightContent) {
  var element = z.dom.getElementById(this.uid_);
  if (!z.isDefAndNotNull(element)) {
    return;
  }

  z.dom.removeChildren(element);
  this.updateButton_(element, 'left', this.leftTitle_, leftContent);
  this.updateButton_(element, 'right', this.rightTitle_, rightContent);
};

/**
 * @param {Element} element
 * @param {String} direction
 * @param {String} title
 * @param {{text: String, link: String}} content
 * @private
 */
z.components.NavBar.prototype.updateButton_ = function (element, direction, title, content) {
  content = content || {};
  var link = content['link'] || null;
  var text = content['text'] || null;
  z.dom.appendNode(element, this.renderButton_(direction, title, link, text));
};

/**
 * @param {String} direction
 * @param {String} title
 * @param {String?} opt_link
 * @param {String?} opt_text
 * @returns {string}
 * @private
 */
z.components.NavBar.prototype.renderButton_ = function (direction, title, opt_link, opt_text) {
  if (z.isDefAndNotNull(opt_link)) {
    return '<a href="' + opt_link + '" class="z-navbar--link z-text--' + direction + '">' +
        '<span class="lnr lnr-arrow-' + direction + ' z-align--' + direction + '"></span>' +
        '<div class="z-text--' + direction + '">' +
        '<span>' + title + '</span><br>' +
        '<span class="z-navbar--' + direction + '-text z-text--headline">' + (opt_text || '') + '</span>' +
        '</div>' +
        '</a>';
  } else {
    return '<div class="z-navbar--link"></div>';
  }
};
