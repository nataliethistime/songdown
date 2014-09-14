'use strict'

Mustache = require 'mustache'
_ = require 'lodash'
glob = require 'glob'
path = require 'path'
fs = require 'fs'
normalizeNewline = require 'normalize-newline'

t = require './songdown/templates'
Song = require './songdown/song'

module.exports =
class Songdown

    constructor: (args = {}) ->

        {@inputDir, @outputDir} = args
        @songsWritten = []

    getFiles: ->
        glob.sync '*.songdown', cwd: @inputDir

    handleNames: (name) ->
        title = name.replace /\.songdown$/, ''
        fname = title.replace(/\s/g, '_') + '.html'
        @songsWritten.push {fname, title}
        [title, fname]

    renderSong: (name, title) ->
        text = normalizeNewline fs.readFileSync(path.join(@inputDir, name)).toString()
        song = new Song text
        Mustache.render t.Song, {song_html: song.toHtml(), title}

    outputSong: (fname, html) ->
        opath = path.join @outputDir, fname
        fs.writeFileSync opath, html

    renderIndex: ->
        return unless @songsWritten.length > 0
        @outputIndex Mustache.render t.Index, songsWritten: @songsWritten

    outputIndex: (html) ->
        fs.writeFileSync path.join(@outputDir, '..', 'index.html'), html

    run: ->
        _.each @getFiles(), (name) =>
            [title, fname] = @handleNames name
            html = @renderSong name, title
            @outputSong fname, html

        @renderIndex()
