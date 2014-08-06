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

    # Some variables for tracking where we are...
    in_verse = false
    verse_num = 0

    lines.each do |line|
        # Here comes the real fun...

        # Verse headers.
        if line =~ /\S+:$/
            line = "<span class='verse-head'>#{line}</span>"
            in_verse = true
        end

        # Verse end marks
        if line =~ /^-{2}$/
            line = '' # Don't show the end mark
            in_verse = false
            verse_num = 0
        end

        # Bold all the chords, assuming every second line in a verse is comprised of chords.
        if verse_num.odd? && !verse_num.zero? && in_verse == true
            line = line.gsub /\s/, '&nbsp;'
            line = "<span class='chords'>#{line}</span>"
        elsif verse_num.even? && !verse_num.zero? && in_verse == true
            line = "<span class='lyrics'>#{line}</span>"
        end


        line += "<br />\n"
        output << line

        verse_num += 1 if in_verse
    end

    output.join ''
end

files = Dir.entries(INPUT).select { |name| name.split('.').last == 'songdown' }
files.each do |name|
    path = File.join INPUT, name
    opath = File.join(OUTPUT, name).gsub! /songdown$/, 'html'
    text = File.read path
    html = compile_songdown text
    html = TEMPLATE.call :song_html => proc { Handlebars::SafeString.new html }
    File.write(opath, html)
    # puts html
end
