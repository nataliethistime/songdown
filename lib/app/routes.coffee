'use strict'

templates = require './templates'

loadSongs = require('./../compiler').songs
Song = require './../compiler/song'

module.exports.init = (app) ->

    assetsUrl = if process.env.PRODUCTION
        'http://songdown.herokuapp.com/static'
    else
        "http://localhost:#{app.get 'port'}/static"

    songDir = app.get 'songDir'


    # Index
    app.route '/'
        .get (req, res) ->
            songs = loadSongs songDir
            crshUrl = req.crsh.libs.name
            res.end templates.index {songs, assetsUrl, crshUrl}

    # Song view
    app.route '/song/:fname'
        .get (req, res) ->

            song = new Song req.param('fname'), songDir
            crshUrl = req.crsh.libs.name

            res.send templates.song
                artist: song.artist
                assetsUrl: assetsUrl
                html: song.toHtml()
                track: song.track
                fname: song.fname
                crshUrl: crshUrl
