'use strict'

path = require 'path'
express = require 'express'
app = express()
logfmt = require 'logfmt'

knexFunc = require 'knex'
bookshelfFunc = require 'bookshelf'

# The most important part is here...
Songdown = require './../compiler'

# Setup the leading man of the scene...
songdown = new Songdown
    inputDir:  path.join __dirname, '..', '..', 'songs'


# TODO: we may not need a db of any kind FIXME.....
knex = knexFunc
    client: 'mysql'
    connection:
        host: 'localhost'
        user: 'root'
        password: '123qwe'
        database: 'songdown_dev'
        #debug: yes

app.use           express.static path.join __dirname, '..', '..', 'static'
app.use '/song/', express.static path.join __dirname, '..', '..', 'static'
app.use logfmt.requestLogger()
app.set 'bookshelf', bookshelfFunc knex
app.set 'songdown', songdown


port = process.env.PORT or 5000
app.listen port, ->
    host = @address().address
    console.log "Songdown listening at http://#{host}:#{port}"


module.exports = app
