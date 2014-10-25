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
            [fname, location, artist, track] = @handleNames name

            songs[artist] ?= []
            songs[artist].push {fname, location, artist, track}

        songs

    handleNames: (fname) ->
        track = fname.replace(/\.songdown$/, '').split '-'
        artist = track.shift().trim()
        track = track.join ''
        location = path.join @inputDir, fname

        # Hillsong - Our God.songdown
        #
        # fname    => 'Hillsong - Our God.songdown'
        # location => 'full/path/to/Hillsong - Our God.songdown'
        # artist   => 'Hillsong'
        # track    => 'Our God'
        [fname.trim(), location, artist.trim(), track.trim()]

    render: (location) ->
        buffer = fs.readFileSync location
        song = new Song normalizeNewline buffer.toString()
        song.toHtml()
