module Nit
  class Command
    class Status < Command
      # Encapsulates the process of computing the file index from `git status`.
      class State # DISCUSS: alternative names: Screen, ScreenState, FileIndexes?
        # TODO: test me.
        def initialize(screen_state, config)
          @screen = Lines.new(screen_state)

          @files, @ignored = files_for(screen, config)
        end
        attr_reader :files, :ignored, :screen

      private
        def files_for(screen, config)
          files = screen.files

          ignored = [] # TODO: that must be implemented by Files.
          files.delete_if { |f| config.ignored_files.include?(f.path) ? ignored << f : false }

          [Files.new(files, config.indexer), Files.new(ignored, config.indexer)]
        end
      end


      def initialize(config)
        super
        extend config.index_renderer
      end

    private
      def process(state, indexes, args)
        files, screen, ignored = state.files, state.screen, state.ignored

        files.each do |file| # TODO: should we have redundant file patterns here? it is better readable, thou.
          ln = file.line
          i  = files.index(file)

          if ln.match(screen.file_patterns[:modified])
            process_modified(i, file, ln)
          elsif ln.match(screen.file_patterns[:new])
            process_new(i, file, ln)
          end
        end

        # TODO: should be pluggable:
        ignore_files(screen, ignored)
        bold_branch(screen)

        screen.to_s
      end

      module AppendIndexRenderer
        def process_modified(i, file, line)
          line << "  [#{i}]"
        end

        def process_new(*args)
          process_modified(*args)
        end
      end

      module PrependIndexRenderer
        def process_modified(i, file, line)
          line.sub!("#\tmodified:", "#\tmodified: [#{i}] ")
        end

        def process_new(i, file, line)
          line.sub!("#\t", "#\t [#{i}] ")
        end
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
end