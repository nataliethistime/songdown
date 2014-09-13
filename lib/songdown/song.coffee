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

        verse_type = null
        verse_start_i = -1

        _.each lines, (line, i) ->
            if line.match Tokens.VERSE_COMMON_HEADER
                verse_type = 'COMMON'
            else if line.match Tokens.VERSE_CHORDS_HEADER
                verse_type = 'CHORDS'
            else if line.match Tokens.VERSE_LYRICS_HEADER
                verse_type = 'LYRICS'

            if verse_type?
                verse_start_i = i
                return no

        markdown = lines.slice(0, verse_start_i).join "\n"
        @nodes.push new Nodes.Markdown markdown

        header = lines[verse_start_i]
        verse = lines.slice verse_start_i + 1, lines.length

        # If there isn't a header, there's pro'lly a loose \n hanging around
        # somewhere causing trouble.
        # TODO: figure out the bug that causes this!
        return unless header?

        @nodes.push new Nodes.VerseHeader header

        switch verse_type
            when 'COMMON'
                @nodes.push new Nodes.VerseCommon verse
            when 'CHORDS'
                @nodes.push new Nodes.VerseChords verse
            when 'LYRICS'
                @nodes.push new Nodes.VerseLyrics verse

    toHtml: ->
        thing = _.map @nodes, (node) -> node.toHtml()
            .join "\n"
