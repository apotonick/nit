module Nit
  class Lines < Array
    def initialize(text)
      super(text.split("\n"))
    end

    def find(patterns)
      each do |ln|
        patterns.find do |typ, pat|
          if matches = ln.match(pat)
            yield ln, pat, matches
            true
          end
        end
      end
    end

    def files
      files = []

      find(file_patterns) do |ln, pat, matches|
        files << file = File.new(matches[1].strip, ln, files.size)

        yield file if block_given?
      end

      files
    end

    def to_s
      join("\n")
    end

  #private
    def file_patterns
      {
        modified: /modified:(.+)/,
        new: /#\t(.+)/
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