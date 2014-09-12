# encoding: utf-8

require 'fileutils'
require 'mustache'
Mustache.template_extension = 'html'

require 'songdown/nodes'
require 'songdown/templates'

class Songdown

    attr_accessor :input
    attr_accessor :output
    attr_accessor :templates

    def initialize(args)
        @input_dir  = args[:input]
        @output_dir = args[:output]

        @tmpl_dir = Mustache.template_path = args[:templates]
    end

    def get_files
        Dir.entries(@input_dir).select { |name| name.split('.').last == 'songdown' }
    end

    def generate_nodes(text)
        nodes = Songdown::Nodes.new text
        nodes.generate
        nodes
    end

    def run
        songs_written = []

        self.get_files.each do |name|
            title = name.gsub /\.songdown$/, '' # Remove .songdown extension
            fname = title.gsub(/\s/, '_') + '.html'
            songs_written << {:fname => fname, :title => title}

            text = File.read File.join @input_dir, name
            output_path = File.join @output_dir, fname

            nodes = self.generate_nodes text
            html = Songdown::Templates::Song.render nodes.vars title
            File.write output_path, html
        end

        index_html = Songdown::Templates::Index.render songs_written: songs_written
        File.write File.join(@output_dir, '..', 'index.html'), index_html

        # Lastly, copy the static folder which has all our JS and CSS in it.
        location = File.join File.dirname(File.expand_path(__FILE__)), 'songdown', 'static'
        FileUtils.cp_r location, @output_dir
    end
end
