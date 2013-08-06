module Nit
  class Commit < Status
    def call(original=`git status`, indexes) # TODO: use from Status.
      screen = Lines.new(original)

      files, ignored  = files_for(screen) # move to somewhere else!

      commit_files = indexes.collect do |i|
        files[i.to_i]
      end

      system "git add #{commit_files.join(" ")} && git commit"
    end
  end
end