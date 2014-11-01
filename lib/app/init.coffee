'use strict'

path = require 'path'
express = require 'express'
app = express()
logfmt = require 'logfmt'
Crsh = require 'crsh'

staticDir = path.join __dirname, '..', '..', 'static'

app.use Crsh.middleware staticDir,
    libs: [
        './js/vendor/jquery.js'
        './js/vendor/anchor.js'
        './js/vendor/d3.js'
        './js/vendor/trianglify.js'
        './coffee/song.coffee'
        './coffee/index.coffee'
    ]

# js, css, assets and the like.
app.use '/static', express.static staticDir

# This is just a 'recommended logger' or something.
app.use logfmt.requestLogger()

app.set 'songDir', path.join __dirname, '..', '..', 'songs'
app.set 'port', process.env.PORT or 5000

module.exports = app
