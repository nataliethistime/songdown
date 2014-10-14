'use strict';

require('coffee-script').register();

var path = require('path');
var location = path.join(__dirname, '..', 'lib', 'songdown', 'app')

// Kick everything off!
require(location);
