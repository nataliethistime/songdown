'use strict'

{index, song} = require './templates'

_ = require 'lodash'

module.exports.init = (app) ->

    bookshelf = app.get 'bookshelf'
    songdown = app.get 'songdown'

    app.route '/'
        .get (req, res) ->
            res.end index {songs: songdown.loadSongs()}

    app.route '/song/:name'
        .get (req, res) ->

            name = req.param('name') + '.songdown'
            [name, title, location, artist] = songdown.handleNames name
            html = songdown.render location

            res.send song {title, html}
