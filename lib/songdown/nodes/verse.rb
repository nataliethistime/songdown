# encoding: utf-8

require 'songdown/node'

class Songdown
    class Nodes
        class Verse < Songdown::Node
            def to_html
                formatted = @section.each_with_index.map do |line, i|
                    # Index is zero-based
                    i += 1

                    if i.odd?
                        '<pre class="chords">' + line + '<br /></pre>'
                    else
                        '<pre class="lyrics">' + line + '<br /></pre>'
                    end
                end

                '<div class="verse">' + formatted.join("\n") + '</div>'
            end
        end
    end
end
