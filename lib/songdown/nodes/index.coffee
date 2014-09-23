'use strict'

marked = require 'marked'

_ = require 'lodash'

Tokens = require './../tokens'

# Base class for everything going on in here...
class Node
    constructor: (@section = 'ERROR!!!') ->
    toHtml: -> throw new Error 'override me please!!!'


# Some simple methods
chordsLine = (line) -> '<pre class="chords">' + line + '<br /></pre>'
lyricsLine = (line) -> '<pre class="lyrics">' + line + '<br /></pre>'
verseBlock = (lines) -> '<span class="verse">' + lines.join("\n") + '</span>'


class VerseHeader extends Node
    toHtml: ->

        # Remove +'s and -'s from header.
        @section = @section.replace Tokens.VERSE_CHORDS_HEADER, Tokens.VERSE_START
        @section = @section.replace Tokens.VERSE_LYRICS_HEADER, Tokens.VERSE_START

        '<div class="verse-head">' + @section + '</div>'


# This verse has chords and lyrics.
class VerseCommon extends Node
    toHtml: ->
        lines = _.map @section, (line, i) ->

            # Chords are on even numbered lines
            if i % 2 == 0
                chordsLine line
            else
                lyricsLine line

        verseBlock lines


class VerseChords extends Node
    toHtml: ->
        lines = _.map @section, chordsLine
        verseBlock lines


class VerseLyrics extends Node
    toHtml: ->
        lines = _.map @section, lyricsLine
        verseBlock lines


class Comments extends Node
    toHtml: ->
        @section = @section.join '<br />'
        marked @section

class GotoVerse extends Node
    toHtml: ->
        @section = @section.replace Tokens.GOTO, ''
        '<p>Play <span class="verse-goto">' + @section + '</span></p>'


module.exports = {VerseHeader, VerseCommon, VerseChords, VerseLyrics, Comments, GotoVerse}
