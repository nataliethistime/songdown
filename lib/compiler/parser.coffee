'use strict'

path = require 'path'
fs = require 'fs'

_ = require 'lodash'
normalizeNewline = require 'normalize-newline'

Tokens = require './tokens'
Nodes = require './nodes'

class Parser

    # One section is the chunk of text from the line after the last verse end
    # to the next verse end point. This means there is exactly one verse and
    # sometimes a comment node we need to find in each section.
    parseSection: (section) ->

        # Filter out blank lines or newlines. This allows the user to be very
        # free with the formatting inside the .songdown file and it won't
        # have an effect on the appearence of the html page.
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

        header = lines[verseStartIndex]
        verse = lines.slice verseStartIndex + 1, lines.length

        comments = if verseStartIndex is -1
            # We're probably at the end of the file, so just grab everything.
            _.clone lines
        else
            # Otherwise, grab from the start of the section to the line before
            # the very's header.
            lines.slice 0, verseStartIndex

        @parseComments comments

        # At the end of the file there can be a comment node to parse, but no
        # verse, if that's the case, stop here.
        return unless verseClass?

        @nodes.push new Nodes.VerseHeader header
        @nodes.push new verseClass verse

    parseComments: (lines) ->
        return unless _.size(lines) > 0

        storage = []
        _.each lines, (line) =>
            if line.match Tokens.GOTO
                @nodes.push new Nodes.Comments storage
                storage = []
                @nodes.push new Nodes.GotoVerse line
            else
                storage.push line

        @nodes.push new Nodes.Comments(storage) if _.size(lines) > 0

    loadConfigValues: ->

        # Go through each comment node and find possible config values
        _.each @nodes, (node) ->
            # TODO implement this!!!

    load: ->
        @text = normalizeNewline fs.readFileSync(@location).toString()

    parse: ->
        @nodes = []
        _.each @text.split(Tokens.VERSE_END), @parseSection, @

        @loadConfigValues()

    toHtml: ->

        @load() if not @text?
        @parse() if not @nodes?

        _.map @nodes, (node) -> node.toHtml()
            .join "\n"

module.exports = Parser
