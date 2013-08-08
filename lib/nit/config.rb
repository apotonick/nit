require "psych"
require "thor"

module Nit
  class Config < Thor::Group # we have to derive from Group to get the create_file working - that's messy.
    include Thor::Actions

    class File
      def initialize(name, app) # FIXME: i hate the app dependency for #create_file.
        @name = name
        @app  = app
      end

      def read(key)
        return unless exist?
        yaml_hash[key]
      end

      def write(key, value)
        @app.create_file(@name) unless exist?

        hash = yaml_hash
        hash[key] = value
        ::File.open(@name, "w") { |f| f.write(Psych.dump(hash))  }
      end

      def rm!
        @app.remove_file(@name)
      end

    private
      def exist?
        ::File.exist?(@name)
      end

      def yaml_hash
        Psych.load_file(@name) || {}
      end
    end


    def initialize
      super
      @file = File.new(filename, self) # FIXME: remove the Thor::App dependency, see above!
    end

    def ignored_files
      file.read("ignored_files") or []
    end

    def add_ignored_files(*files)
      arr = ignored_files
      arr += files.collect(&:to_s)
      file.write("ignored_files", arr)
    end

  private
    attr_reader :file

    def filename
      ".nit"
    end
  end
end