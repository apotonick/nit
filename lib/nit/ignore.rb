module Nit
  class Ignore < Status
  private
    def process(state, indexes)
      return show if indexes.size == 0

      indexes.each do |i|
        @config.add_ignored_files state.evaluate([i]) # FIXME: let thor make coercion.
      end
    end

    def show
      ignores = @config.ignored_files
      return if ignores.size == 0

      output = "Ignored files:\n"
      ignores.each { |f| output << "[#{ignores.index(f)}] #{f}\n" }

      output
    end
  end
end