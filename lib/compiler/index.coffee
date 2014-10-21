'use strict'

_ = require 'lodash'

glob = require 'glob'
path = require 'path'
fs = require 'fs'
normalizeNewline = require 'normalize-newline'

# WARNING: this require path **WILL** change in future!!!!
templates = require './../app/templates'

Song = require './song'

module.exports =
class Songdown

    constructor: (args = {}) ->

        {@inputDir, @outputDir} = args
        @songsWritten = {}

    getFiles: ->
        glob.sync '*.songdown', cwd: @inputDir

    handleNames: (name) ->
        title = name.replace /\.songdown$/, ''
        fname = title.replace(/\s/g, '_') + '.html'
        [title, fname]

    renderSong: (name, title) ->
        text = normalizeNewline fs.readFileSync(path.join(@inputDir, name)).toString()
        song = new Song text
        templates.song {song_html: song.toHtml(), title}

    outputSong: (fname, html) ->
        opath = path.join @outputDir, fname
        fs.writeFileSync opath, html

    handleIndexEntry: (title, fname) ->
        splitted = title.split '-'
        artist = splitted.shift().trim()
        name = splitted.join('-').trim()

        @songsWritten[artist] ?= []
        @songsWritten[artist].push {fname, name}

    renderIndex: ->
        return unless _.size(Object.keys(@songsWritten)) > 0
        @outputIndex templates.index {@songsWritten}

    outputIndex: (html) ->
        fs.writeFileSync path.join(@outputDir, 'index.html'), html

    run: ->
        _.each @getFiles(), (name) =>
            [title, fname] = @handleNames name
            html = @renderSong name, title
            @outputSong fname, html
            @handleIndexEntry title, fname

        @renderIndex()
