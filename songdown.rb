# encoding: utf-8


require 'fileutils'
require 'handlebars'

cwd = File.expand_path Dir.getwd
INPUT = File.join cwd, 'songs'
OUTPUT = File.join cwd, 'output'

# Make sure
FileUtils.mkdir_p INPUT
FileUtils.mkdir_p OUTPUT

handlebars = Handlebars::Context.new
TEMPLATE = handlebars.compile File.read File.join cwd, 'index-template.html'

def compile_songdown(text)
    output = []

    lines = text.split "\n"

    lines.each do |line|
        # Here comes the real fun...

        # Verse headers.
        if line =~ /\S+:$/
            output << "<i>#{line}</i><br />"
            next
        end
    end

    output.join ''
end

files = Dir.entries(INPUT).select { |name| name.split('.').last == 'songdown' }
files.each do |name|
    path = File.join INPUT, name
    opath = File.join(OUTPUT, name).gsub! /songdown$/, 'html'
    text = File.read path
    html = compile_songdown text
    File.write(opath, html)
end
