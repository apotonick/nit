module Nit
  class Status
    def initialize(config)
      @config = config
    end

    def call(original=`git status`)
      screen = Lines.new(original)

      ignore_files(screen)

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

    def ignore_files(lines)
      return unless ignored_files.size > 0

      #puts "officially ignored: #{ignored_files.inspect}"

      pattern = /(\t|\s)(#{ignored_files.join("|")})$/

      deleted = []

      lines.find(pattern) do |ln, matches|
        deleted << ln
      end

      deleted.each(&:delete)

      lines << "#   Ignored files: #{ignored_files.size}"
    end

    def ignored_files
      @config.ignored_files
    end
  end
end