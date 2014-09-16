'use strict'

fs = require 'fs'
{join} = require 'path'

read = (name) ->
    fs.readFileSync(join(__dirname, name)).toString()

module.exports =
    song  : read 'song.html'
    index : read 'index.html'
