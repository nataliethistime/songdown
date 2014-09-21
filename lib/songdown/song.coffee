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

        lines = _.filter section.split(Tokens.NEWLINE), (line) ->
            line isnt '\n' and line isnt ''

        return unless _.size(lines) > 0

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

        @parseMarkdown lines.slice(0, verseStartIndex).join "\n"

        header = lines[verseStartIndex]
        verse = lines.slice verseStartIndex + 1, lines.length

        @nodes.push new Nodes.VerseHeader header

        switch verseType
            when 'COMMON'
                @nodes.push new Nodes.VerseCommon verse
            when 'CHORDS'
                @nodes.push new Nodes.VerseChords verse
            when 'LYRICS'
                @nodes.push new Nodes.VerseLyrics verse

    parseMarkdown: (lines) ->
        @nodes.push new Nodes.Markdown lines

    toHtml: ->
        _.map @nodes, (node) -> node.toHtml()
            .join "\n"
