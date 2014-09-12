# encoding: utf-8

require 'songdown/node'

class Songdown
    class Nodes
        class VerseHeader < Songdown::Node
            def to_html
                @section.gsub! Songdown::Tokens::VERSE_CHORDS_HEADER, Songdown::Tokens::VERSE_START
                @section.gsub! Songdown::Tokens::VERSE_LYRICS_HEADER, Songdown::Tokens::VERSE_START
                '<br /><span class="verse-head">' + @section + '</span><br />'
            end
        end
    end
end
