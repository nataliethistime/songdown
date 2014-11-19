'use strict'

path = require 'path'
fs = require 'fs'

_ = require 'lodash'

Parser = require './parser'

class Song extends Parser
    constructor: (fname, @songDir) ->

        [@fname, @location, @artist, @track] = @handleNames fname
        @names = {@artist, @fname, @location, @track}
        @text = null
        @nodes = null

    handleNames: (fname) ->
        track = fname.replace(/\.songdown$/, '').split '-'
        artist = track.shift().trim()
        track = track.join ''
        location = path.join @songDir, fname

        # Given 'Hillsong - Our God.songdown':
        # fname    => 'Hillsong - Our God.songdown'
        # location => 'full/path/to/Hillsong - Our God.songdown'
        # artist   => 'Hillsong'
        # track    => 'Our God'
        [fname.trim(), location, artist.trim(), track.trim()]

    # The Node docs state fs.exists() to be an anti-pattern. This is because the files can change
    # between checking and opening. It would be better to just open the file and handle the error.
    # However, the songs diretory will never change during the running of the app and doing latter
    # implementation would result in the need of a callback or a try/catch. This is much easer and
    # won't actually cause the problems specified in the docs. :)
    exists: -> console.log( @location); fs.existsSync @location

module.exports = Song
