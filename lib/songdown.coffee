'use strict'

Mustache = require 'mustache'
_ = require 'lodash'
glob = require 'glob'
path = require 'path'
fs = require 'fs'
normalizeNewline = require 'normalize-newline'

t = require './songdown/templates'
Song = require './songdown/song'

class Songdown

    constructor: (args = {}) ->

        {@input_dir, @output_dir} = args
        @songs_written = []

    getFiles: ->
        glob.sync '*.songdown', cwd: @input_dir

    handleNames: (name) ->
        title = name.replace /\.songdown$/, ''
        fname = title.replace(/\s/g, '_') + '.html'
        @songs_written.push {fname, title}
        [title, fname]

    renderSong: (name, title) ->
        text = normalizeNewline fs.readFileSync(path.join(@input_dir, name)).toString()
        song = new Song text
        Mustache.render t.Song, {song_html: song.toHtml(), title}

    outputSong: (fname, html) ->
        opath = path.join @output_dir, fname
        fs.writeFileSync opath, html

    renderIndex: ->
        return unless @songs_written.length > 0
        @outputIndex Mustache.render t.Index, songs_written: @songs_written

    outputIndex: (html) ->
        fs.writeFileSync path.join(@output_dir, '..', 'index.html'), html

    run: ->
        _.each @getFiles(), (name) =>
            [title, fname] = @handleNames name
            html = @renderSong name, title
            @outputSong fname, html

        @renderIndex()

module.exports = Songdown
