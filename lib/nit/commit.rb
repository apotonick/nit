module Nit
  class Commit < Status
    def process(state, indexes)
      system "git add #{state.evaluate(indexes)} && git commit"
    end
  end
end