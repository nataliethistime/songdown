'use strict'

path = require 'path'
express = require 'express'
app = express()
logfmt = require 'logfmt'

# The most important part is here...
Songdown = require './../compiler'

# Setup the leading man of the scene...
songDir = path.join __dirname, '..', '..', 'songs'
songdown = new Songdown
    inputDir:  songDir

# js, css, assets and the like.
app.use '/static', express.static path.join __dirname, '..', '..', 'static'

# This is just a 'recommended logger' or something.
app.use logfmt.requestLogger()

# Store the reference to the intiialized Songdown object so that other stuff has access.
app.set 'songdown', songdown
app.set 'songDir', songDir
app.set 'port', process.env.PORT or 5000

module.exports = app
