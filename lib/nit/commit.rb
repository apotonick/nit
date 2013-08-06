module Nit
  class Commit < Status
    def process(screen, files, ignored, indexes) # TODO: use from Status.
      commit_files = indexes.collect do |i|
        files[i.to_i]
      end

      system "git add #{commit_files.join(" ")} && git commit"
    end
  end
end