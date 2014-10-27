'use strict'

_ = require 'lodash'

# This method is based mostly off of this SO answer http://stackoverflow.com/a/7936871.
# I've modified it to be more coffee-like and to output flats instead of sharps.
transposeChord = (chord, increment) ->

    splitted = chord.split '/'
    if splitted.length > 1
        return _.map splitted, (chordPart) -> transposeChord chordPart, increment
            .join '/'

    scale = 'C Db D Eb E F Gb G Ab A Bb B'.split ' '
    length = scale.length
    root = chord.charAt(0);

    if chord.length > 1
        if chord.charAt(1) == '#'
            increment += 2 # counter act turning a sharp into flat.
            root += 'b'
        else if chord.charAt(1) == 'b'
            root += 'b'

    index = scale.indexOf root
    newIndex = (index + increment + length) % length
    scale[newIndex] + chord.substring root.length

module.exports.transposeChord = transposeChord
