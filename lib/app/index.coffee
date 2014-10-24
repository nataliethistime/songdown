'use strict'

app = module.exports = require './init'
routes = require './routes'

# Download all the songs and get started.
down = require 'download-github-repo'

console.log 'Downloading the songs'
down 'Vasari/songdown-songs', app.get('songDir'), (err) ->
    if err
        throw new Error err

    console.log 'Initializing routes'
    routes.init app

    console.log 'Starting server'
    app.listen app.get('port'), ->
        host = @address().address
        console.log "Songdown listening at http://#{host}:#{app.get('port')}"
