'use strict'

{index, song} = require './templates'

module.exports.init = (app) ->

    bookshelf = app.get 'bookshelf'
    songdown = app.get 'songdown'

    app.route '/'
        .get (req, res) ->
            res.end index {songs: songdown.loadSongs()}

    app.route '/song/:fname'
        .get (req, res) ->

            fname = req.param 'fname'
            [fname, location, artist, track] = songdown.handleNames fname
            html = songdown.render location

            res.send song {artist, track, html}
