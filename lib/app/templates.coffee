'use strict'

fs = require 'fs'
path = require 'path'
Handlebars = require 'handlebars'

templateFromFname = (name) ->
    str = fs.readFileSync path.join __dirname, '..', 'templates', name
        .toString()

    Handlebars.compile str

module.exports =
    song  : templateFromFname 'song.hbs'
    index : templateFromFname 'index.hbs'
