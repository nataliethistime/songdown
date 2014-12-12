'use strict'

app = module.exports = require './init'
routes = require './routes'

# Download all the songs and get started.
down = require 'download-github-repo'

_ = require 'lodash'

{isEmptySync} = require 'extfs'
{ncp} = require 'ncp'
del = require 'del'


path = require 'path'

downloadSongs = (callback) ->
    down '1Vasari/songdown-songs', app.get('songDir'), (err) ->

        if err and isEmptySync app.get 'songDir'
            throw new Error err

        callback()


copySongs = (sourcePath, callback) ->
    # Use negative look-ahead to ignore .git and copy everything else.
    opts = {filter: /^(?!.*\.git)/}
    ncp sourcePath, app.get('songDir'), opts, (err) ->
        # I don't really know when or how this could happen, but I guess we'll see... :P
        throw err if err?

        callback()


listen = ->
    routes.init app

    app.listen app.get('port'), ->
        host = @address().address
        console.log "Songdown listening at http://#{host}:#{app.get 'port'}."


module.exports.start = ->
    console.log 'Doing initial setup Stuff.'

    # Clear out the songs dir.
    app.get 'songDir'
    del.sync ['*', '*.*', '!.git'], {cwd: app.get 'songDir'}

    sourcePath = path.join __dirname, '..', '..', '..', 'songdown-songs'
    if not isEmptySync sourcePath
        console.log 'Local songdown-songs detected.'
        copySongs sourcePath, listen
    else
        console.log 'Downloading songdown-songs from Github.'
        downloadSongs listen
