'use strict'

templates = require './templates'

module.exports.init = (app) ->

    bookshelf = app.get 'bookshelf'

    # app.route '/'
    #     .get (req, res) ->
    #         res.end templates.index {}
