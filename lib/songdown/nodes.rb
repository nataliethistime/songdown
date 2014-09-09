# encoding: utf-8

require 'songdown/tokens'
require 'songdown/nodes/verse'
require 'songdown/nodes/verse_head'


class Songdown
    class Nodes
        def initialize(text)
            @text = text
            @nodes = []
        end

        def generate
            @text.split(Songdown::Tokens::VERSE_END).each { |s| self.parse_section s }
        end

        def parse_section(section)
            is_verse = false
            verse = []

            section.split(Songdown::Tokens::NEWLINE).each do |line|

                if is_verse && line != Songdown::Tokens::VERSE_END
                    verse << line
                    next
                end

                if line =~ Songdown::Tokens::VERSE_HEAD
                    is_verse = true
                    @nodes << Songdown::Nodes::VerseHead.new(line)
                    next
                end

                # Do this later... :D
                # @nodes << Songdown::Nodes::MarkDown.new(line)
            end

            if is_verse && verse.size > 0
                @nodes << Songdown::Nodes::Verse.new(verse)
            end
        end

        def to_html
            @nodes.map(&:to_html).join "\n"
        end

        def vars(title)
            {
                :song_html => self.to_html,
                :title => title,
            }
        end
    end
end
