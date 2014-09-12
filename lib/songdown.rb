# encoding: utf-8

require 'fileutils'
require 'mustache'
Mustache.template_extension = 'html'

require 'songdown/song'
require 'songdown/templates'

class Songdown

    attr_accessor :input
    attr_accessor :output
    attr_accessor :templates

    def initialize(args)
        @input_dir  = args[:input]
        @output_dir = args[:output]

        @tmpl_dir = Mustache.template_path = args[:templates]

        @songs_written = []
    end

    def get_files
        Dir.entries(@input_dir).select { |name| name.split('.').last == 'songdown' }
    end

    def handle_names(name)
        title = name.gsub /\.songdown$/, '' # Remove .songdown extension
        fname = title.gsub(/\s/, '_') + '.html'
        @songs_written.push fname: fname, title: title
        [title, fname]
    end

    def render_song(name, title)
        text = File.read File.join @input_dir, name
        song = Songdown::Song.new text
        Songdown::Templates::Song.render song_html: song.to_html, title: title
    end

    def output_song(fname, html)
        output_path = File.join @output_dir, fname
        File.write output_path, html
    end

    def render_index
        html = Songdown::Templates::Index.render songs_written: @songs_written
        self.output_index html
    end

    def output_index(html)
        File.write File.join(@output_dir, '..', 'index.html'), html
    end

    def handle_assets
        location = File.join File.dirname(File.expand_path(__FILE__)), 'songdown', 'static'
        FileUtils.cp_r location, @output_dir
    end

    def run
        self.get_files.each do |name|
            title, fname = self.handle_names name
            html = self.render_song name, title
            self.output_song fname, html
        end

        self.render_index
        self.handle_assets
    end
end
