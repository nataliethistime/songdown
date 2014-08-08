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
TEMPLATE = handlebars.compile File.read File.join cwd, 'song-template.html'
INDEX = handlebars.compile File.read File.join cwd, 'index-template.html'

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
            line = "<div class='verse'><span class='verse-head'>#{line}</span>"
            in_verse = true
        end

        # Verse end marks
        if line == '---'
            # Note: we don't show the '---' bit.
            line = '</div>'

            in_verse = false
            verse_num = 0
        end

        # Bold all the chords, assuming every second line in a verse is comprised of chords.
        if verse_num.odd? && !verse_num.zero? && in_verse == true
            line = line.gsub /\s/, '&nbsp;'
            line = "<div class='chords'>#{line}</div>"
        elsif verse_num.even? && !verse_num.zero? && in_verse == true
            line = line.gsub /\s/, '&nbsp;'
            line = "<div class='lyrics'>#{line}</div>"
        end


        if in_verse == true
            line += "\n"
        else
            line += "<br />\n"
        end

        output << line

        verse_num += 1 if in_verse
    end

    output.join ''
end

files = Dir.entries(INPUT).select { |name| name.split('.').last == 'songdown' }
names = []
files.each do |name|
    title = name.gsub /\.songdown$/, '' # Remove .songdown extension
    names << title

    path = File.join INPUT, name
    opath = File.join OUTPUT, title + '.html'

    text = File.read path
    vars = {
        :song_html => proc { Handlebars::SafeString.new compile_songdown text },
        :title => title
    }

    html = TEMPLATE.call vars
    File.write opath, html
end

File.write(File.join(cwd, 'index.html'), INDEX.call(:names => names.sort))
