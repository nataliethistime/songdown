'use strict'

path = require 'path'

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

module.exports = Song
