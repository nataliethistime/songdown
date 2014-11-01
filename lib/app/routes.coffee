'use strict'

templates = require './templates'

loadSongs = require('./../compiler').songs
Song = require './../compiler/song'

module.exports.init = (app) ->

    songDir = app.get 'songDir'

    getAssetsUrl = (req) ->
        if process.env.PRODUCTION?
            "#{req.protocol}://songdown.herokuapp.com/static"
        else
            "#{req.protocol}://localhost:#{app.get 'port'}/static"


    # Index
    app.route '/'
        .get (req, res) ->
            songs = loadSongs songDir
            crshUrl = req.crsh.libs.name
            res.end templates.index {songs, assetsUrl: getAssetsUrl(req), crshUrl}

    # Song view
    app.route '/song/:fname'
        .get (req, res) ->

            song = new Song req.param('fname'), songDir
            crshUrl = req.crsh.libs.name

            res.send templates.song
                artist: song.artist
                assetsUrl: getAssetsUrl(req)
                html: song.toHtml()
                track: song.track
                fname: song.fname
                crshUrl: crshUrl
