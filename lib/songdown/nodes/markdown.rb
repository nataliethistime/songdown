# encoding: utf-8

require 'songdown/node'

require 'kramdown'

class Songdown
    class Nodes
        class Markdown < Songdown::Node
            def to_html
                Kramdown::Document.new(@section, input: 'GFM').to_html
            end
        end
    end
end
