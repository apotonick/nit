module Nit
  class Ignore < Status
  private
    def process(screen, files, ignored, indexes)
      indexes.each do |i|
        @config.add_ignored_files files[i].to_s
      end
    end
  end
end