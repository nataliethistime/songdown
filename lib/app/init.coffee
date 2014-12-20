'use strict'

path = require 'path'
express = require 'express'
app = express()
logfmt = require 'logfmt'
Crsh = require 'crsh'

SongCache = require './song-cache'

# Do some stuff to force HTTPS all the time.
forceSsl = (req, res, next) ->
    if req.headers['x-forwarded-proto'] isnt 'https'
        res.redirect "https://#{req.get 'host'}#{req.url}"
    else
        next()

app.use(forceSsl) if process.env.PRODUCTION

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
app.set 'songCache', new SongCache app.get 'songDir'
app.set 'port', process.env.PORT or 5000

module.exports = app
