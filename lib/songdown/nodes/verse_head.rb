# encoding: utf-8

require 'songdown/node'

class SongDown
    class Nodes
        class VerseHead < SongDown::Node
            def to_html
                '<span class="verse-head">' + @section + '</span><br />'
            end
        end
    end
end
