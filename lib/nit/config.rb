require "psych"
require "thor"

module Nit
  class Config < Thor::Group # we have to derive from Group to get the create_file working - that's messy.
    include Thor::Actions
    # Warning: this API will soon change.

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
        @app.create_file(@name, Psych.dump({})) unless exist?

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

    def ignored_files=(files)
      file.write("ignored_files", files.collect(&:to_s))
    end

    def indexer
      const = file.read("indexer") || "CharIndexer"
      Nit::Files.const_get(const)
    end

    def indexer=(value)
      file.write("indexer", value)
    end

    def index_renderer
      const = file.read("index_renderer") || "AppendIndexRenderer"
      Nit::Status.const_get(const)
    end

  private
    attr_reader :file

    def filename
      ".nit"
    end
  end
end