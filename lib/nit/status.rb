module Nit
  class Status
    def call
      output = `git status`
      output << "\033[1mbold\033[22m"

      screen = Lines.new(output)

      screen.files do |file| # TODO: should we have redundant file patterns here? it is better readable, thou.
        ln = file.line
        if ln.match(screen.file_patterns[:modified])
          ln.sub!("#\tmodified:", "#\tmodified: [#{file.i}] ")
        elsif ln.match(screen.file_patterns[:new])
          ln.sub!("#\t", "#\t [#{file.i}] ")
        end
      end



      screen.to_s
    end
  end
end