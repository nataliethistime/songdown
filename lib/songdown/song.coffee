'use strict'

_ = require 'lodash'

Tokens = require './tokens'
Nodes = require './nodes'

module.exports =
class Song
    constructor: (text) ->
        @text = text
        @nodes = []

        _.each @text.split(Tokens.VERSE_END), @parseSection

    # One section is the chunk of text from the line after the last verse end
    # to the next verse end point. This means there is exactly one verse and
    # sometimes a markdown node we need to find in each section.
    parseSection: (section) =>

        lines = section.split Tokens.NEWLINE

        verseType = null
        verseStartIndex = -1

        _.each lines, (line, i) ->
            if line.match Tokens.VERSE_COMMON_HEADER
                verseType = 'COMMON'
            else if line.match Tokens.VERSE_CHORDS_HEADER
                verseType = 'CHORDS'
            else if line.match Tokens.VERSE_LYRICS_HEADER
                verseType = 'LYRICS'

            if verseType?
                verseStartIndex = i
                return no

        markdown = lines.slice(0, verseStartIndex).join "\n"
        @nodes.push new Nodes.Markdown markdown

        header = lines[verseStartIndex]
        verse = lines.slice verseStartIndex + 1, lines.length

        # If there isn't a header, there's pro'lly a loose \n hanging around
        # somewhere causing trouble.
        # TODO: figure out the bug that causes this!
        return unless header?

        @nodes.push new Nodes.VerseHeader header

        switch verseType
            when 'COMMON'
                @nodes.push new Nodes.VerseCommon verse
            when 'CHORDS'
                @nodes.push new Nodes.VerseChords verse
            when 'LYRICS'
                @nodes.push new Nodes.VerseLyrics verse

    toHtml: ->
        _.map @nodes, (node) -> node.toHtml()
            .join "\n"
