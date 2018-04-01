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

z.require('components');
z.require('dom');


function navigate(bookmark) {
  if (bookmark.length === 0) {
    bookmark = 'getting-started';
  }

  var links = menu.getElementsByTagName('A');
  for (var i = 0; i < links.length; i++) {
    var link = links[i];
    if ((link.getAttribute('data-bookmark') === bookmark)
        || (link.getAttribute('data-bookmark') === bookmark.substr(0, bookmark.indexOf('_')))) {
      var categoryName = link.getAttribute('data-category');
      var sectionName = link.getAttribute('data-section') || '';
      openSection(categoryName.toLowerCase(), sectionName.toLowerCase());

      var title = formatSection(categoryName, sectionName);
      document.getElementById('top').getElementsByTagName('h2')[0].innerText = title;

      var prevLink = i > 0 ? links[i - 1] : null;
      var nextLink = i < (links.length - 1) ? links[i + 1] : null;
      navBar.update(extractNavLink(prevLink), extractNavLink(nextLink));
    }
  }
}

function extractNavLink(link) {
  if (!z.isDefAndNotNull(link)) {
    return null;
  }

  var text = link.getAttribute('data-section') || link.getAttribute('data-category');
  var anchor = link.getAttribute('data-bookmark');
  return {'text': formatSection(text, null), 'link': (z.isDefAndNotNull(anchor) ? ('#' + anchor) : null)};
}

function formatSection(categoryName, sectionName) {
  var title = z.isDefAndNotNull(categoryName) ? categoryName.replace('-', ' ') : null;
  if (z.isDefAndNotNull(sectionName) && sectionName.length > 0) {
    title += (' - ' + sectionName.replace('-', ' '));
  }
  return title;
}

function openSection(categoryName, sectionName) {
  var content = document.getElementById('content');
  var sections = content.getElementsByTagName('section');

  for (var i = 0; i < sections.length; i++) {
    sections[i].style.display = 'none';
  }

  for (i = 0; i < sections.length; i++) {
    var section = sections[i];
    if (section.id === categoryName || section.id === sectionName) {
      if ((navBar.currentSection || '') !== section.id) {
        window.scrollTo(0, 0);
        navBar.currentSection = section.id;
      }

      while (z.isDefAndNotNull(section) && section.tagName === 'SECTION') {
        section.style.display = 'block';
        section = section.parentNode;
      }
    }
  }
}


var navBar = new z.components.NavBar('Previous', 'Next');
navBar.render('navBar');


var menu = document.getElementById('menu');
menu.addEventListener('click', function (e) {
  if (e.target.tagName === 'A') {
    location.hash = '#' + e.target.getAttribute('data-bookmark');
    e.stopPropagation();
    e.preventDefault();
  }
});

window.addEventListener('hashchange', function (e) {
  navigate(location.hash.substr(1));
}, false);

window.addEventListener('load', function (e) {
  navigate(location.hash.substr(1));
});
