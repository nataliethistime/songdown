# encoding: utf-8

class Songdown
    class Tokens
        VERSE_START = ':'
        VERSE_END = '---'
        VERSE_COMMON_HEADER = /\:$/
        VERSE_CHORDS_HEADER = /\+$/
        VERSE_LYRICS_HEADER = /\-$/
        NEWLINE = "\n"
    end
end
