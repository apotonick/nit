class Nit::Command
  class Commit < Status
    def process(state, indexes, args)
      system "git add #{state.files.list(indexes)} && git commit #{args.join(" ")}"
    end
  end
end