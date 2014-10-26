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
            res.end templates.index {songs: songs(app.get('songDir')), assetsUrl}

    # Song view
    app.route '/song/:fname'
        .get (req, res) ->

            song = new Song req.param('fname'), app.get 'songDir'

            res.send templates.song
                artist: song.getArtist()
                assetsUrl: assetsUrl
                html: song.toHtml()
                track: song.getTrack()


    # Transpose a song
    # app.route '/song/transpose/:fname/:amount'
    #     .get (req, res) ->
    #
    #         fname = req.param 'fname'
    #         interval = req.param 'interval'
    #         html = songdown.render location
    #
    #         res.send song {artist, track, html}
