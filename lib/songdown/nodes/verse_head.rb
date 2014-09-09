# encoding: utf-8

require 'songdown/node'

class Songdown
    class Nodes
        class VerseHead < Songdown::Node
            def to_html
                '<br /><span class="verse-head">' + @section + '</span><br />'
            end
        end
    end
end
