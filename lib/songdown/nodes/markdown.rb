# encoding: utf-8

require 'songdown/node'

require 'kramdown'

class Songdown
    class Nodes
        class Markdown < Songdown::Node
            def to_html
                html = Kramdown::Document.new(@section, input: 'GFM').to_html
                "<p>#{html}</p>"
            end
        end
    end
end
