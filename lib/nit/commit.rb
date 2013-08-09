module Nit
  class Commit < Status
    def process(state, indexes)
      system "git add #{state.files.list(indexes)} && git commit"
    end
  end
end