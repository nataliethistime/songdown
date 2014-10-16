'use strict'

path = require 'path'
express = require 'express'
app = express()

port = process.env.PORT or 5000

app.use express.static path.join __dirname, '..', '..', 'static'
app.set 'bookshelf', require './bookshelf-init'
app.listen port, ->

    host = @address().address
    console.log "Songdown listening at http://#{host}:#{port}"

module.exports = app
