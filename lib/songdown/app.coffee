'use strict'

path = require 'path'
express = require 'express'
app = express()

app.use express.static path.join __dirname, '..', '..', 'static'
app.set 'bookshelf', require './bookshelf-init'
app.listen 5000, ->

    host = @address().address
    port = @address().port

    console.log "Songdown listening at http://#{host}:#{port}"

module.exports = app
