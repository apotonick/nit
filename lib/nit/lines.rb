module Nit
  class Lines < Array
    def initialize(text)
      super(text.split("\n"))
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
          files << file = File.new(matches[1].strip, ln, files.size)

          yield file if block_given?
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

  class File
    def initialize(path, line, i)
      @path, @line, @i = path, line, i
    end

    attr_reader :path, :line, :i

    def to_s
      path
    end
  end
end