'use strict'

templates = require './templates'

{songs} = require './../compiler'
Song = require './../compiler/song'

module.exports.init = (app) ->

    assetsUrl = if process.env.PRODUCTION
        'http://songdown.herokuapp.com/static'
    else
        "http://localhost:#{app.get 'port'}/static"


    # Index
    app.route '/'
        .get (req, res) ->
            songs = songs app.get 'songDir'
            res.end templates.index {songs, assetsUrl}

    # Song view
    app.route '/song/:fname'
        .get (req, res) ->

            song = new Song req.param('fname'), app.get 'songDir'

            res.send templates.song
                artist: song.artist
                assetsUrl: assetsUrl
                html: song.toHtml()
                track: song.track
                fname: song.fname


    # Transpose a song
    app.route '/song/transpose/:fname/:increment'
        .get (req, res) ->

            song = new Song req.param('fname'), app.get 'songDir'
            song.transpose req.param 'increment'

            res.send song.toHtml()
