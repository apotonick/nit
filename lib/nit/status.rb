module Nit
  class Status
    # Encapsulates the process of computing the file index from `git status`.
    class State # DISCUSS: alternative names: Screen, ScreenState, FileIndexes?
      # TODO: test me.
      def initialize(screen_state, ignored_files)
        @screen = Lines.new(screen_state)

        @files, @ignored = files_for(screen, ignored_files)
      end
      attr_reader :files, :ignored, :screen

    private
      def files_for(screen, ignored_files)
        files = screen.files

        ignored = [] # TODO: that must be implemented by Files.
        files.delete_if { |f| ignored_files.include?(f.path) ? ignored << f : false }

        [Files.new(files), Files.new(ignored)]
      end
    end

    def initialize(config)
      @config = config
    end

    def call(original=`git status`, *args)
      state = State.new(original, @config.ignored_files)

      process(state, *args)
    end

  private
    def process(state)
      files, screen, ignored = state.files, state.screen, state.ignored

      files.each do |file| # TODO: should we have redundant file patterns here? it is better readable, thou.
        ln = file.line
        i  = files.index(file)

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

    def bold_branch(lines)
      lines.find(/# On branch (.+)/) do |ln, matches|
        line = "# On branch \033[1m#{matches[1]}\033[22m"
        ln.replace(line)
      end
    end

    def ignore_files(screen, ignored)
      return unless ignored.size > 0

      ignored.each { |f| f.line.delete  }
      screen << "#"
      screen << "#   Ignored files: #{ignored.size}"
    end
  end
end