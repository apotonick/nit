require "psych"
require "thor"

module Nit
  class Config < Thor::Group
    include Thor::Actions

    def ignored_files
      if exist? and hash = Psych.load_file(filename)
        puts "ignored: #{hash.inspect}"
        return hash["ignored_files"]
      end

      []
    end

    def add_ignored_files(*files)
      unless exist?
        puts "CREAAAAAT: #{Psych.dump({"ignored_files" => files})}"
        return create_file filename, Psych.dump({"ignored_files" => files})
      end

      hash = Psych.load_file(filename)
      puts "open:"+hash.inspect

      #hash[:ignored_files] ||= []
      hash["ignored_files"] += files

      puts "about to dump: #{hash.inspect}"

      #create_file filename, Psych.dump(hash)
      ::File.open(filename, "w") { |f| f.write(Psych.dump(hash))  }

      puts "dumped:"+ Psych.dump(hash)
    end

    def exist?
      ::File.exist?(filename)
    end

    def rm_config
      remove_file(filename)
    end

  private
    def filename
      ".nit"
    end

  #   def config
  #   name =
  #   create_file(name) unless
  #   Psych.load_file(name)
  # end
  end
end