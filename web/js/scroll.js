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

var targetOffset,
    body = document.body,
    html = document.documentElement,
    buttons = document.getElementsByClassName('scrollButton');

/**
 * @returns {number}
 */
function getPageScrollOffset() {
  var yScroll;

  if (window.pageYOffset) {
    yScroll = window.pageYOffset;
  } else if (document.documentElement && document.documentElement.scrollTop) {
    yScroll = document.documentElement.scrollTop;
  } else if (document.body) {
    yScroll = document.body.scrollTop;
  }
  return yScroll;
}

/**
 * @param {number} currentPosition
 * @param {number} targetOffset
 * @param {String} className
 * @param {number} animateTime
 */
function scroll(currentPosition, targetOffset, className, animateTime) {
  var delta = -1 * (targetOffset - currentPosition);
  body.classList.add(className);
  body.style.WebkitTransform = "translate(0, " + delta + "px)";
  body.style.MozTransform = "translate(0, " + delta + "px)";
  body.style.transform = "translate(0, " + delta + "px)";

  window.setTimeout(function () {
    body.classList.remove(className);
    body.style.cssText = "";
    window.scrollTo(0, targetOffset);
  }, animateTime);
}

document.addEventListener('keydown', function (event) {
  if (event.keyCode === 38 || event.keyCode === 40) {
    event.preventDefault();
    var offset = getPageScrollOffset();
    var height = Math.max(document.documentElement.clientHeight, window.innerHeight || 256);
    var bodyHeight = Math.max(body.scrollHeight, body.offsetHeight,
        html.clientHeight, html.scrollHeight, html.offsetHeight);

    if (event.keyCode === 38) {
      scroll(offset, Math.max(offset - height, 0), 'scroll', 500);
    } else if (event.keyCode === 40) {
      scroll(offset, Math.min(offset + height, bodyHeight - height), 'scroll', 500);
    }
  }
});


for (var i = 0; i < buttons.length; i++) {
  var button = buttons.item(i);
  button.addEventListener('click', function (event) {
    var button = event.target;
    while (button.tagName !== 'A') {
      button = button.parentNode;
    }

    var sectionName = button.hash.substr(1);
    targetOffset = document.getElementById(sectionName).offsetTop;
    scroll(getPageScrollOffset(), targetOffset, 'scroll-smooth', 900);
    event.preventDefault();
  }, false);
}
