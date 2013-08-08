module Nit
  class Ignore < Status
  private
    def process(state, indexes)
      return show if indexes.size == 0

      file_list = indexes.collect do |i|
        file = state.evaluate_index(i)
      end.compact

      @config.add_ignored_files *file_list
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