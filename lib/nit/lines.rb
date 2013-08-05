module Nit
  class Lines < Array
    def initialize(text)
      super(text.split("\n"))
    end

    def process

    end

    def find
      each do |ln|
        file_patterns.find do |typ, pat|
          if matches = ln.match(pat)
            yield ln, pat, matches
            true
          end
        end
      end
    end

    def files
      files = []

      find do |ln, pat, matches|
        files << name = matches[1].strip
        # this is for rendering new screen only, don't like it.
        yield ln, files.index(name) if block_given? # DISCUSS: pass File object which knows index, line, etc?
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
end