'use strict'

fs = require 'fs'
{join} = require 'path'

read = (name) ->
    fs.readFileSync(join(__dirname, name)).toString()

module.exports =
    Song  : read 'song.html'
    Index : read 'index.html'
