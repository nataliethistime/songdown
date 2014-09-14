'use strict';

// Some default variables...
var FONT_SIZE = 16;
var FADE_TIME = 300; // milli-seconds

function init() {
    $('#fontSize').attr('value', FONT_SIZE);
    setFontSize(FONT_SIZE);

    initEvents();
    showContent();
}

function initEvents() {
    $('#fontSize').off().on('change', function() {
        setFontSize(parseInt($(this).val(), 10));
    });

    $('#viewSelector').off().on('change', function() {
        changeViewMode(parseInt($(this).val(), 10));
    })

    // Note: a CSS media query handles the hiding of the sidebar and making
    //   sure that none of the verses are cut across pages.
    $('#printButton').off().on('click', function(event) {
        event.preventDefault();
        window.print();
    });
}

function showContent() {
    $('#song').css('display', '').hide().fadeIn(FADE_TIME);
}

function setFontSize(size) {
    size = size || FONT_SIZE;
    $('#song').css('font-size', size + 'px');
}

function changeViewMode(num) {

    // Show Chords and Lyrics
    if (num === 0) {
        $('.chords, .lyrics').fadeIn(FADE_TIME);
    }
    // Lyrics only.
    else if (num === 1) {
        $('.chords').fadeOut(FADE_TIME);
        $('.lyrics').fadeIn(FADE_TIME);
    }
}

$(window.document).on('ready', init);
