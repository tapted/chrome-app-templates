/**
 * @license Copyright 2013 Google Inc. All rights reserved.
 * Use of this source code is governed by the Apache license that can be
 * found in the LICENSE file.
 */

chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('index.html', {
    'width': 900,
    'height': 700
  });
});
