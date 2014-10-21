'use strict'

path = require 'path'
express = require 'express'
app = express()
logfmt = require 'logfmt'

knexFunc = require 'knex'
bookshelfFunc = require 'bookshelf'

# Before we try anything dramatic, let's compile all the songdown files.
# Note: this is a hack solution to a problem that will take quite a while to
# properly solve.
Songdown = require './../compiler'

# Organise some paths and shit.
job = new Songdown
    inputDir:  path.join __dirname, '..', '..', 'songs'
    outputDir: path.join __dirname, '..', '..', 'html'
job.run()

knex = knexFunc
    client: 'mysql'
    connection:
        host: 'localhost'
        user: 'root'
        password: '123qwe'
        database: 'songdown_dev'
        #debug: yes

port = process.env.PORT or 5000

app.use express.static path.join __dirname, '..', '..', 'html'
app.use logfmt.requestLogger()
app.set 'bookshelf', bookshelfFunc knex

app.listen port, ->

    host = @address().address
    console.log "Songdown listening at http://#{host}:#{port}"

module.exports = app
