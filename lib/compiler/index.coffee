'use strict'

_ = require 'lodash'

glob = require 'glob'
path = require 'path'
fs = require 'fs'
normalizeNewline = require 'normalize-newline'

Song = require './song'

module.exports =
class Songdown

    constructor: (args = {}) ->

        {@inputDir, @outputDir} = args

    getFiles: ->
        glob.sync '*.songdown', cwd: @inputDir

    loadSongs: ->
        songs = {}

        _.each @getFiles(), (name) =>
            [name, title, location, artist] = @handleNames name

            songs[artist] ?= []
            songs[artist].push {name, title, location, artist}

        songs

    handleNames: (name) ->
        name = name.trim()
        title = name.replace /\.songdown$/, ''
        location = path.join @inputDir, name
        artist = title.split('-').shift().trim()
        title = title.trim()

        [name, title, location, artist]

    render: (location) ->
        buffer = fs.readFileSync location
        song = new Song normalizeNewline buffer.toString()
        song.toHtml()
