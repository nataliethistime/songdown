'use strict'

_ = require 'lodash'
{ncp} = require 'ncp'
del = require 'del'
down = require 'download-github-repo'
extfs = require 'extfs'

path = require 'path'

module.exports =
class SongCache


    constructor: (@dir) ->
        # nothin'

    create: (@callback) ->
        console.log 'Initializing the song cache.'

        # Clear out the songs dir. Ignore '.git' because it has Symlinks which Windows can't handle.
        del.sync ['*', '*.*', '!.git'], {cwd: @dir}

        @source = path.join __dirname, '..', '..', '..', 'songdown-songs'

        if not extfs.isEmptySync @source
            console.log 'Local songdown-songs repo detected, using it.'
            @copySongs()
        else
            console.log 'Downloading songdown-songs from Github.'
            @downloadSongs()


    downloadSongs: ->
        down '1Vasari/songdown-songs', @dir, (err) =>

            if err and extfs.isEmptySync @dir
                throw new Error err

            @callback()


    copySongs: ->
        # Use negative look-ahead to ignore .git and copy everything else.
        opts = {filter: /^(?!.*\.git)/}
        ncp @source, @dir, opts, (err) =>
            # I don't really know when or how this could happen, but I guess we'll see... :P
            throw err if err?

            @callback()
