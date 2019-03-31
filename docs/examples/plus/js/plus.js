/*
 * Copyright 2019 The zensational authors.
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

z.require('dom');
z.require('net');


var topics_ = [];
var lastCount_ = 0;
var lastSearch_ = null;
var searchInput_ = z.dom.getElementById('search');
var searchResult_ = z.dom.getElementById('ebda1a');
var reloadButton_ = z.dom.getElementByClass('E3qfYc');


/**
 * @param {number} index
 * @returns {string}
 */
var getCard = function (index) {
  var topic = topics_[index];
  if (!z.isDefAndNotNull(topic.dom)) {
    topic.dom = renderCard_(index, topic['id'], topic['title'], topic['color'], topic['image']);
  }
  return topic.dom;
};

/**
 * @param {number} index
 * @param {string} id
 * @param {string} title
 * @param {string} color
 * @param {string} image
 * @returns {string}
 */
var renderCard_ = function (index, id, title, color, image) {
  return '' +
      '<div id="topic_' + id + '" class="z-cell z-cell--3-col NzRmxf vCjazd">' +
      '<h2 class="SDJOje"></h2>' +
      '<a class="w2Aa4 wRd1We kUqoPd" style="' + color + '" href="">' +
      '<div>' +
      '<div class="E68jgf" style="padding-top: 56.25%"><img class="JZUAbb" src="images/' + image + '" height="180" width="320" alt=""></div>' +
      '</div>' +
      '<div class="Cri5O"><div class="t8kvre">' + title + '</div>' +
      '<div class="nerE3c"><div class="UUUH4c"><div class="U26fgb O0WRkf oG5Srb C0oVfc B7Nypc aKZ15">' +
      '<div class="Vwe4Vb MbhUzd"></div>' +
      '<div class="ZFr60d CeoRYc"></div>' +
      '<content class="CwaK9"><span class="RveJvd snByac"><div class="Yak35d">Follow</div></span></content>' +
      '</div></div></div>' +
      '</div>' +
      '</a>' +
      '</div>';
};

/**
 * @param {number} number
 */
var addCards = function (number) {
  var value = searchInput_.value.toLowerCase();
  for (var i = 0, added = 0; i < topics_.length && added < number; i++) {
    var topic = topics_[i];
    var matches = topic['title'].toLowerCase().indexOf(value);
    if (matches >= 0 && !z.isDefAndNotNull(z.dom.getElementById('topic_' + topic['id']))) {
      z.dom.appendNode(searchResult_, getCard(i));
      lastCount_++;
      added++;
    }
  }

  var visClass = 'z--visible';
  var loadStatus = z.dom.getElementById('loadStatus');
  var loadError = z.dom.getElementById('loadError');
  loadStatus.classList.remove(visClass);
  loadError.classList.remove(visClass);

  if (lastCount_ < 5) {
    loadStatus.classList.add(visClass);
    if (!z.isDefAndNotNull(lastSearch_)) {
      lastSearch_ = new Date();
      setTimeout(function () {
        lastSearch_ = null;
        loadStatus.classList.remove(visClass);
        if (lastCount_ < 5) {
          loadStatus.classList.remove(visClass);
          loadError.classList.add(visClass)
        }
      }, 5000);
    }
  } else {
    loadStatus.classList.remove(visClass);
  }
};

/**
 * @returns {number}
 */
var getPageScrollOffset = function () {
  var yScroll;

  if (window.pageYOffset) {
    yScroll = window.pageYOffset;
  } else if (document.documentElement && document.documentElement.scrollTop) {
    yScroll = document.documentElement.scrollTop;
  } else if (document.body) {
    yScroll = document.body.scrollTop;
  }
  return yScroll;
};


z.net.get('topics.json', function (response) {
  topics_ = JSON.parse(response.target.responseText);

  var searchResult = z.dom.getElementById('ebda1a');
  while (searchResult.childElementCount < Math.min(30, topics_.length)) {
    var number = Math.floor(Math.random() * topics_.length);
    if (!z.isDefAndNotNull(topics_[number].dom)) {
      z.dom.appendNode(searchResult, getCard(number));
    }
  }
});

document.addEventListener('scroll', function (e) {
  var offset = getPageScrollOffset();
  var height = Math.max(document.documentElement.clientHeight, window.innerHeight || 256);
  var bodyHeight = Math.max(document.body.scrollHeight, document.body.offsetHeight,
      document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);

  if (offset + height + 200 > bodyHeight) {
    addCards(20);
  }
});

searchInput_.addEventListener('keyup', function (e) {
  z.dom.removeChildren(searchResult_);
  lastCount_ = 0;

  addCards(30);
});

reloadButton_.addEventListener('click', function (e) {
  location.reload(true);
});
