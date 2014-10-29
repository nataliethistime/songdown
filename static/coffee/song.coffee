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


    $ '#transposeSelector'
        .off()
        .on 'change', ->
            increment = parseInt($(this).val(), 10)

            $('#song').fadeOut FADE_TIME, ->
                # TODO Do the transposing here!
                $(this).html(data).fadeIn FADE_TIME


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

        # Hide chords
        when 1
            $ '.verse.chords'
                .fadeOut FADE_TIME
            $ '.verse.lyrics'
                .fadeIn FADE_TIME


changeTheme = (url) ->

    # Make sure the value stored in localStorage actually is a theme we can use
    # and 'select' the theme in the dropdown box.
    el = $('option', '#themeSelector').filter(->
        $(this).val() is url
    )[0]

    return unless el

    $(el).attr 'selected', true

    # Store for next time.
    localStorage.lastUsedTheme = url
    $ '#themeCssElement'
        .attr 'href', url


$ window.document
    .ready ->
        init() if $('#song').length
