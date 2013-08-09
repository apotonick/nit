module Nit
  class Ignore < Status
    def initialize(*)
      super
      @ignores = Files.new(@config.ignored_files)
    end
    attr_reader :ignores

  private
    def process(state, indexes)
      return show if indexes.size == 0

      file_list = state.files.evaluate(indexes).compact

      @config.ignored_files=(@config.ignored_files + file_list)
    end

    def show
      return if ignores.size == 0

      output = "Ignored files:\n"
      ignores.each { |f| output << "[#{ignores.index(f)}] #{f}\n" }

      output
    end
  end

  class Unignore < Ignore
  private
    def process(state, indexes)
      file_list = state.ignored.evaluate(indexes).compact

      @config.ignored_files=(@config.ignored_files - file_list.map(&:to_s)) # FIXME: make this work with strings and File instances.
    end
  end
end