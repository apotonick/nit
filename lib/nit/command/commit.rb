class Nit::Command
  class Commit < Status
    def process(state, indexes, args)
      handle_m!(args)
      system "git add #{state.files.list(indexes)} && git commit #{args.join(" ")}"
    end

  private
    def handle_m!(args)
      return unless i = args.index("-m")

      args[i+1] = "\"#{args[i+1]}\""
    end
  end
end