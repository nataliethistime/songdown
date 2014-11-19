'use strict'

marked = require 'marked'
_ = require 'lodash'

Tokens = require './tokens'

# Base class for everything going on in here...
class Node
    constructor: (@section = 'ERROR!!!') ->
    toHtml: -> throw new Error 'override me please!!!'


chordsLine = (line) -> '<div class="verse-chords">' + line + '</div>'
lyricsLine = (line) -> '<div class="verse-lyrics">' + line + '</div>'

# The closing <div> here is opened at the start of a verse (before the header).
# NOTE: we also have the \n's in there to make debugging easier.
verseBlock = (lines) -> lines.join("\n") + '</div>\n\n'


class VerseHeader extends Node
    toHtml: ->

        # Remove +'s and -'s from header.
        @section = @section.replace Tokens.VERSE_CHORDS_HEADER, Tokens.VERSE_START
        @section = @section.replace Tokens.VERSE_LYRICS_HEADER, Tokens.VERSE_START

        # The leading <div> here is closed at the end of the verse.
        '<div class="verse-wrap"><div class="verse-title">' + @section + '</div>'


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


# This verse just has chords.
class VerseChords extends Node
    toHtml: ->
        lines = _.map @section, chordsLine
        verseBlock lines


# This verse just has lyrics.
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
        line = @section.replace Tokens.GOTO, ''

        # Let's take this slow...
        dynamicsMatch = _.first(/\(.+\)/i.exec(line)) or null
        repeatMatch   = _.first(/x\s?\d+/i.exec(line)) or null

        # Attempt to get the title of the verse, that this goto is referring to, by itself.
        titleStr = line.replace(dynamicsMatch or '', '').replace(repeatMatch or '', '').trim()

        # Now that we've extracted the important information from the original line,
        # let's get some HTML on the grill! :D

        title = '<span class="goto-title">' + titleStr + '</span>'
        dynamics = if dynamicsMatch?
            '<span class="goto-dynamics">' + dynamicsMatch + '</span>'
        else ''
        repeat = if repeatMatch?
            '<span class="goto-repeat">' + repeatMatch + '</span>'
        else ''

        # The final thing that we've made.
        html = [title, dynamics, repeat].join ' '
        "<p>Play #{html}</p>"


module.exports = {VerseHeader, VerseCommon, VerseChords, VerseLyrics, Comments, GotoVerse}
