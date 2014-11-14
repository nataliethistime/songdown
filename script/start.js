'use strict';

require('coffee-script').register();

var path = require('path');
var location = path.join(__dirname, '..', 'lib', 'app');

// Clear the cache so that everything is reloaded properly.
require.cache = {};

// Kick everything off!
var app = require(location);
app.start();
