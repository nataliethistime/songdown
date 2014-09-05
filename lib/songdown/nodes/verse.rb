# encoding: utf-8

require 'songdown/node'

class SongDown
    class Nodes
        class Verse < SongDown::Node
            def to_html
                formatted = @section.each_with_index.map do |line, i|
                    # Index is zero-based
                    i += 1

                    if i.odd?
                        '<div class="chords">' + line + '</div>'
                    else
                        '<div class="lyrics">' + line + '</div>'
                    end
                end

                '<pre class="verse">' + formatted.join("\n") + '</pre>'
            end
        end
    end
end
