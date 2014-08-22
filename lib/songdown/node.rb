# encoding: utf-8

class SongDown
    class Node
        def initialize(section)
            @section = section
        end

        def to_html
            raise 'Override me!!'
        end
    end
end
