'use strict'

themeUrl = (name) ->
    "#{window.ASSETS_URL}/css/theme-#{name}.css"


FONT_SIZE = 16
FADE_TIME = 300

THEMES = [
    {
        name: 'Default'
        url: themeUrl 'default'
    }
    {
        name: 'Colourful'
        url: themeUrl 'colourful'
    }
]


init = ->
    $ '#fontSize'
        .attr 'value', FONT_SIZE
    setFontSize FONT_SIZE

    # Initialize the theme selector.
    $el = $ '#themeSelector'
    $el.append "<option value=\"#{theme.url}\">#{theme.name}</option>" for theme in THEMES

    initEvents()
    initAnchors()
    initTheme()
    showContent()


initEvents = ->
    $ '#fontSize'
        .off()
        .on 'change', ->
            setFontSize parseInt($(this).val(), 10)


    $ '#viewSelector'
        .off()
        .on 'change', ->
            changeViewMode parseInt($(this).val(), 10)


    $ '#themeSelector'
        .off()
        .on 'change', ->
            changeTheme $(this).val()


    previous = 0
    $ '#transposeSelector'
        .off()
        .on 'change', ->

            val = parseInt $(this).val(), 10
            increment = val - previous
            previous = val

            $('#song').fadeOut FADE_TIME, ->

                $ '.verse.chords'
                    .each ->
                        line = $(@).text()
                        line = transposeLine line, increment
                        $(@).html line

                $(this).fadeIn FADE_TIME


    # Note: a CSS media query handles the hiding of the sidebar and making
    #   sure that none of the verses are cut across pages.
    $ '#printButton'
        .off()
        .on 'click', (event) ->
            event.preventDefault()
            window.print()


initAnchors = ->
    window.addAnchors '.verse.title'


initTheme = ->
    changeTheme localStorage.lastUsedTheme or THEMES[0].url


showContent = ->
    $ '#song'
        .fadeIn FADE_TIME


setFontSize = (size = FONT_SIZE) ->
    $ '#song'
        .css 'font-size', "#{size}px"


changeViewMode = (num) ->
    switch num
        # Show lyrics and chords
        when 0
            $ '.verse.chords, .verse.lyrics'
                .fadeIn FADE_TIME

        # Show lyrics
        # Hide chords
        when 1
            $ '.verse.chords'
                .fadeOut FADE_TIME
            $ '.verse.lyrics'
                .fadeIn FADE_TIME


changeTheme = (url) ->

    # Make sure the value stored in localStorage actually is a theme we can use.
    el = $('option', '#themeSelector').filter(->
        $(this).val() is url
    )[0]

    return unless el?

    # Set it as the selected value.
    $ el
        .attr 'selected', true

    # Store for next time.
    localStorage.lastUsedTheme = url
    $ '#themeCssElement'
        .attr 'href', url


transposeLine = (line, increment) ->
    line.replace /\S+/g, (match) -> transposeChord match, increment


# This method is based mostly off of this SO answer http://stackoverflow.com/a/7936871.
# I've modified it to be more coffee-like and to output flats instead of sharps.
transposeChord = (chord, increment) ->

    splitted = chord.split '/'
    if splitted.length > 1
        return $.map splitted, (chordPart) -> transposeChord chordPart, increment
            .get()
            .join '/'

    scale = 'C Db D Eb E F Gb G Ab A Bb B'.split ' '
    length = scale.length
    root = chord.charAt 0

    if chord.length > 1
        if chord.charAt(1) == '#'
            increment += 2 # counter act turning a sharp into flat.
            root += 'b'
        else if chord.charAt(1) == 'b'
            root += 'b'

    index = scale.indexOf root
    newIndex = (index + increment + length) % length
    scale[newIndex] + chord.substring root.length



$ window.document
    .ready ->
        init() if $('#song').length
