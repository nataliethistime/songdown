# encoding: utf-8

require 'songdown/tokens'
require 'songdown/nodes/verse'
require 'songdown/nodes/verse_head'


class SongDown
    class Nodes
        def initialize(text)
            @text = text
            @nodes = []
        end

        def generate
            @text.split(SongDown::Tokens::VERSE_END).each { |s| self.parse_section s }
        end

        def parse_section(section)
            is_verse = false
            verse = []

            section.split(SongDown::Tokens::NEWLINE).each do |line|

                if is_verse && line != SongDown::Tokens::VERSE_END
                    verse << line
                    next
                end

                if line =~ SongDown::Tokens::VERSE_HEAD
                    is_verse = true
                    @nodes << SongDown::Nodes::VerseHead.new(line)
                    next
                end

                # Do this later... :D
                # @nodes << SongDown::Nodes::MarkDown.new(line)
            end

            if is_verse && verse.size > 0
                @nodes << SongDown::Nodes::Verse.new(verse)
            end
        end

        def to_html
            @nodes.map(&:to_html).join "\n"
        end

        def render(title, template)
            song_html = self.to_html
            vars = {
                :song_html => proc { Handlebars::SafeString.new song_html },
                :title => title
            }
            template.call vars
        end
    end
end
