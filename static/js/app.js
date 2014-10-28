'use strict';

// Some default variables...
var FONT_SIZE = 16;
var FADE_TIME = 300; // milli-seconds

// All the themes 'n' stuff.
var THEMES = [
    {
        name : 'Default',
        url  : themeUrl('default')
    },
    {
        name : 'Colourful',
        url  : themeUrl('colourful')
    }
];

function themeUrl(name) {
    return window.ASSETS_URL + '/css/theme-' + name + '.css';
}

function init() {
    $('#fontSize').attr('value', FONT_SIZE);
    setFontSize(FONT_SIZE);

    // Initialize the theme selector.
    var $el = $('#themeSelector');
    for (var i = 0; i < THEMES.length; i++) {
        var theme = THEMES[i];
        $el.append('<option value="' + theme.url + '">' + theme.name + '</option>');
    }

    initEvents();
    initAnchors();
    initTheme();
    showContent();
}

function initEvents() {
    $('#fontSize').off().on('change', function() {
        setFontSize(parseInt($(this).val(), 10));
    });

    $('#viewSelector').off().on('change', function() {
        changeViewMode(parseInt($(this).val(), 10));
    });

    $('#themeSelector').off().on('change', function() {
        changeTheme($(this).val());
    });

    $('#transposeSelector').off().on('change', function() {
        var increment = parseInt($(this).val(), 10);

        // Do a lil HTTP request here.
        $.get('/song/transpose/' + window.FNAME + '/' + increment, function(data) {
            if (data) {
                $('#song').fadeOut(FADE_TIME, function() {
                    $(this).html(data).fadeIn(FADE_TIME);
                });
            }
        });
    });

    // Note: a CSS media query handles the hiding of the sidebar and making
    //   sure that none of the verses are cut across pages.
    $('#printButton').off().on('click', function(event) {
        event.preventDefault();
        window.print();
    });
}

function initAnchors() {
    window.addAnchors('.verse.title');
}

function initTheme() {
    var url = localStorage.lastUsedTheme || THEMES[0].url;
    changeTheme(url);
}

function showContent() {
    $('#song').fadeIn(FADE_TIME);
}

function setFontSize(size) {
    size = size || FONT_SIZE;
    $('#song').css('font-size', size + 'px');
}

function changeViewMode(num) {

    // Show Chords and Lyrics
    if (num === 0) {
        $('.verse.chords, .verse.lyrics').fadeIn(FADE_TIME);
    }
    // Lyrics only.
    else if (num === 1) {
        $('.verse.chords').fadeOut(FADE_TIME);
        $('.verse.lyrics').fadeIn(FADE_TIME);
    }
}

function changeTheme(url) {
    // Make sure the value stored in localStorage actually is a theme we can use
    // and 'select' the theme in the dropdown box.
    var el = $('option', '#themeSelector').filter(function() {
        return $(this).val() === url;
    })[0];

    if (!el) {
        return;
    }

    $(el).attr('selected', true);

    // Store for next time.
    localStorage.lastUsedTheme = url;
    $('#themeCssElement').attr('href', url);
}

$(window.document).ready(init);
