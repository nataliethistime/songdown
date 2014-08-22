# encoding: utf-8

require 'fileutils'
require 'handlebars'

require 'songdown/nodes'

class SongDown

    attr_accessor :input
    attr_accessor :output
    attr_accessor :templates

    def initialize(args)
        @input_dir  = args[:input]
        @output_dir = args[:output]
        @tmpl_dir   = args[:templates]

        handlebars = Handlebars::Context.new
        @templates = {
            :index => handlebars.compile(File.read(File.join @tmpl_dir, 'index.html')),
            :song => handlebars.compile(File.read(File.join @tmpl_dir, 'song.html')),
        }
    end

    def get_files
        Dir.entries(@input_dir).select { |name| name.split('.').last == 'songdown' }
    end

    def generate_nodes(text)
        nodes = SongDown::Nodes.new text
        nodes.generate
        nodes
    end

    def write_output(output_path, content)
        File.write output_path, content
    end

    def run
        names = []
        self.get_files.each do |name|
            title = name.gsub /\.songdown$/, '' # Remove .songdown extension
            fname = title.gsub(/\s/, '_') + '.html'
            names << {:fname => fname, :title => title}

            text = File.read File.join @input_dir, name
            output_path = File.join @output_dir, fname

            nodes = self.generate_nodes text
            html = nodes.render title, @templates[:song]
            self.write_output output_path, html
        end
    end
end
