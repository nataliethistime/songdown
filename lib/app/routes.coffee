'use strict'

{index, song} = require './templates'
# Document = require './../compiler/document'

module.exports.init = (app) ->

    bookshelf = app.get 'bookshelf'
    songdown = app.get 'songdown'

    assetsUrl = if process.env.PRODUCTION
        'http://songdown.herokuapp.com/static'
    else
        "http://localhost:#{app.get 'port'}/static"


    # Index
    app.route '/'
        .get (req, res) ->
            res.end index {songs: songdown.loadSongs(), assetsUrl}

    # Song view
    app.route '/song/:fname'
        .get (req, res) ->

            fname = req.param 'fname'
            [fname, location, artist, track] = songdown.handleNames fname
            html = songdown.render location

            res.send song {artist, track, html, assetsUrl}


    # Transpose a song
    app.route '/song/transpose/:fname/:amount'
        .get (req, res) ->

            fname = req.param 'fname'
            interval = req.param 'interval'
            [fname, location, artist, track] = songdown.handleNames fname
            html = songdown.render location

            res.send song {artist, track, html}
