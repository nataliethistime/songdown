'use strict'

path = require 'path'
express = require 'express'
app = express()
logfmt = require 'logfmt'

# js, css, assets and the like.
app.use '/static', express.static path.join __dirname, '..', '..', 'static'

# This is just a 'recommended logger' or something.
app.use logfmt.requestLogger()

app.set 'songDir', path.join __dirname, '..', '..', 'songs'
app.set 'port', process.env.PORT or 5000

module.exports = app
