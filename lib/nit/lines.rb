module Nit
  class Lines < Array
    def initialize(text)
      super(text.split("\n").collect { |ln| Line.new(ln, self) })
    end

    def find(pattern)
      each do |ln|
        next unless matches = ln.match(pattern)

        yield ln, matches
      end
    end

    def files
      files = []

      for type, pattern in file_patterns
        find(pattern) do |ln, matches|
          files << file = File.new(matches[1].strip, ln)
        end
      end

      files
    end

    def to_s
      join("\n")
    end

  #private
    def file_patterns
      {
        modified: /#\tmodified:(.+)/,
        new: /#\t([^modified:].+)/
      }
    end
  end

  class Line < String
    def initialize(string, screen)
      super(string)
      @screen = screen
    end

    # Deletes the entire line from the screen.
    def delete
      @screen.delete(self)
    end
  end

  class File
    def initialize(path, line)
      @path, @line = path, line
    end

    attr_reader :path, :line

    def to_s
      path.to_s
    end
  end

  class Files < Array

  end
end