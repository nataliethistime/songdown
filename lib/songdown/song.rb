# encoding: utf-8

require 'songdown/tokens'
require 'songdown/nodes/verses'
require 'songdown/nodes/verse_header'
require 'songdown/nodes/markdown'


class Songdown
    class Song
        def initialize(text)
            @text = text
            @nodes = []

            @text.split(Songdown::Tokens::VERSE_END).each { |s| self.parse_section s }
        end

        # One section is the chunk of text from the line after the last verse end
        # to the next verse end point. This means there is exactly one verse and
        # sometimes a note node we need to find in each section.
        def parse_section(section)
            lines = section.split Songdown::Tokens::NEWLINE

            # Skip empty sections and lines
            return unless lines.size > 0

            verse_type = ''
            verse_start_i = -1

            lines.each_with_index.each do |line, i|
                verse_type =
                    case line
                    when Songdown::Tokens::VERSE_COMMON_HEADER then 'COMMON'
                    when Songdown::Tokens::VERSE_CHORDS_HEADER then 'CHORDS'
                    when Songdown::Tokens::VERSE_LYRICS_HEADER then 'LYRICS'
                    else next
                    end

                verse_start_i = i
                break
            end

            markdown = Array(lines.slice(0, verse_start_i)).join "\n"
            @nodes.push Songdown::Nodes::Markdown.new markdown

            header = lines[verse_start_i]
            verse = lines.slice verse_start_i + 1, lines.size

            @nodes.push Songdown::Nodes::VerseHeader.new header

            case verse_type
            when 'COMMON'
                @nodes.push Songdown::Nodes::VerseCommon.new verse
            when 'CHORDS'
                @nodes.push Songdown::Nodes::VerseChords.new verse
            when 'LYRICS'
                @nodes.push Songdown::Nodes::VerseLyrics.new verse
            end
        end

        def to_html
            @nodes.map(&:to_html).join "\n"
        end
    end
end
