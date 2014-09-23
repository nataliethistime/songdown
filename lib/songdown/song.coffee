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

        verseClass = null
        verseStartIndex = -1

        _.each lines, (line, i) ->
            if line.match Tokens.VERSE_COMMON_HEADER
                verseClass = Nodes.VerseCommon
            else if line.match Tokens.VERSE_CHORDS_HEADER
                verseClass = Nodes.VerseChords
            else if line.match Tokens.VERSE_LYRICS_HEADER
                verseClass = Nodes.VerseLyrics

            if verseClass?
                verseStartIndex = i
                return no

        # Avoid null issues...
        return unless verseClass?

        @parseMarkdown lines.slice 0, verseStartIndex

        header = lines[verseStartIndex]
        verse = lines.slice verseStartIndex + 1, lines.length

        @nodes.push new Nodes.VerseHeader header
        @nodes.push new verseClass verse

    parseMarkdown: (lines) ->
        return unless lines.length > 0

        storage = []
        _.each lines, (line) =>
            if line.match Tokens.GOTO
                @nodes.push new Nodes.Comment storage.join "\n"
                storage = []

                # Remove the GOTO token before adding to the nodes list.
                line = line.replace Tokens.GOTO, ''
                @nodes.push new Nodes.GotoVerse line
            else
                storage.push line

        @nodes.push new Nodes.Comment storage.join "\n"

    toHtml: ->
        _.map @nodes, (node) -> node.toHtml()
            .join "\n"
