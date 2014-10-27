'use strict'

_ = require 'lodash'

glob = require 'glob'
path = require 'path'
fs = require 'fs'

Song = require './song'

module.exports.songs = (songDir) ->
    songs = {}
    files = glob.sync '*.songdown', cwd: songDir

    _.each files, (name) ->
        song = new Song name, songDir
        songs[song.artist] ?= []
        songs[song.artist].push song.names

    songs
