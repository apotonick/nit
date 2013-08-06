module Nit
  class Status
    def initialize(config)
      @config = config
    end

    def call(original=`git status`)
      screen = Lines.new(original)

      files, ignored  = files_for(screen) # move to somewhere else!

      files.each_with_index do |file, i| # TODO: should we have redundant file patterns here? it is better readable, thou.
        ln = file.line

        if ln.match(screen.file_patterns[:modified])
          ln.sub!("#\tmodified:", "#\tmodified: [#{i}] ")
        elsif ln.match(screen.file_patterns[:new])
          ln.sub!("#\t", "#\t [#{i}] ")
        end
      end

      # TODO: should be pluggable:
      ignore_files(screen, ignored)
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

    def files_for(screen)
      files = screen.files

      ignored = [] # TODO: that must be implemented by Files.
      files.delete_if { |f| ignored_files.include?(f.path) ? ignored << f : false }

      [files, ignored]
    end

    def ignore_files(screen, ignored)
      return unless ignored.size > 0

      ignored.each { |f| f.line.delete  }
      screen << "#   Ignored files: #{ignored.size}"
    end

    def ignored_files
      @config.ignored_files
    end
  end
end