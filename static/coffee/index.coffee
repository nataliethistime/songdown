'use strict'

doc = window.document
interval = null

generateBackground = ->
    t = new Trianglify
        noiseIntensity: 0
        cellsize: 120

    $doc = $ doc
    pattern = t.generate $doc.width(), $doc.height()
    $ 'body'
        .css 'background-image', pattern.dataUrl


resetInterval = ->
    clearInterval interval
    interval = setInterval generateBackground, 60 * 1000


init = ->

    # Do the background thang.
    generateBackground()
    resetInterval()
    $ doc
        .scroll resetInterval


$ window.document
    .ready ->
        init() if $('ul.songs').length
