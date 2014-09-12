# encoding: utf-8

require 'songdown/node'


# I think these 3 methods *should* be in a proper class somewhere. But I don't think
# there's any reason for them to be used elsewhere. So, they're living here for now.

def chords_line(line)
    '<pre class="chords">' + line + '<br /></pre>'
end

def lyrics_line(line)
    '<pre class="lyrics">' + line + '<br /></pre>'
end

def verse_block(lines)
    '<div class="verse">' + lines.join("\n") + '</div>'
end



class Songdown
    class Nodes

        # This verse has chords and lyrics.
        class VerseCommon < Songdown::Node
            def to_html
                lines = Array(@section).each_with_index.map do |line, i|
                    # Index is zero-based
                    i += 1

                    if i.odd?
                        chords_line line
                    else
                        lyrics_line line
                    end
                end

                verse_block lines
            end
        end

        class VerseChords < Songdown::Node
            def to_html
                lines = Array(@section).map { |line| chords_line line }
                verse_block lines
            end
        end

        class VerseLyrics < Songdown::Node
            def to_html
                lines = Array(@section).map { |line| lyrics_line line }
                verse_block lines
            end
        end
    end
end
