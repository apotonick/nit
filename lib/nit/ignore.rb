module Nit
  class Ignore < Status
  private
    def process(state, indexes)
      indexes.each do |i|
        @config.add_ignored_files state.evaluate([i]) # FIXME: let thor make coercion.
      end
    end
  end
end