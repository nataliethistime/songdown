'use strict'

path = require 'path'
express = require 'express'
app = express()
logfmt = require 'logfmt'

# The most important part is here...
Songdown = require './../compiler'

# Setup the leading man of the scene...
songdown = new Songdown
    inputDir:  path.join __dirname, '..', '..', 'songs'

# Mount the static dir onto / and /song so that everything has access to the stuff.
app.use           express.static path.join __dirname, '..', '..', 'static'
app.use '/song/', express.static path.join __dirname, '..', '..', 'static'

# This is just a 'recommended logger' or something.
app.use logfmt.requestLogger()

# Store the reference to the intiialized Songdown object so that other stuff has access.
app.set 'songdown', songdown

# Finally, setup the server. Heroku sets the PORT env var so that everything gets
# setup on the right port.
port = process.env.PORT or 5000
app.listen port, ->
    host = @address().address
    console.log "Songdown listening at http://#{host}:#{port}"


module.exports = app
