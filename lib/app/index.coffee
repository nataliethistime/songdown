'use strict'

app = require './init'
routes = require './routes'


module.exports.start = ->
    app.get('songCache').create ->
        routes.init app

        app.listen app.get('port'), ->
            host = @address().address
            console.log "Songdown listening at http://#{host}:#{app.get 'port'}."
