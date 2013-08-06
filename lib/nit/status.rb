module Nit
  class Status
    def call
      output = `git status`

      screen = Lines.new(output)

      screen.files do |file| # TODO: should we have redundant file patterns here? it is better readable, thou.
        ln = file.line
        if ln.match(screen.file_patterns[:modified])
          ln.sub!("#\tmodified:", "#\tmodified: [#{file.i}] ")
        elsif ln.match(screen.file_patterns[:new])
          ln.sub!("#\t", "#\t [#{file.i}] ")
        end
      end

      bold_branch(screen)

      screen.to_s
    end

  private
    def bold_branch(lines)
      lines.find(/# On branch (.+)/) do |ln, matches|
        line = "# On branch \033[1m#{matches[1]}\033[22m"
        ln.replace(line)
      end
    end
  end
end