require "thor"
require "nit/files"
require "nit/lines"
require "nit/config"
require "nit/command"
require "nit/command/status"
require "nit/command/commit"
require "nit/command/ignore"
require "nit/command/push"
require "nit/command/pull"
require "nit/command/dynamic"


# TODO:
# * diff workflow: going through changed files, adding them while reading!
# * nit unstage => git reset HEAD
# * nit ignore (save time and last changed!)
# * nit unignore
# * nit co -a => git commit -a
# * nit co 1<tab> => filename

module Nit
  class App < Thor
    include Actions

    default_command(:status)

    desc "status", "bla"
    def status(*args)
      puts Command::Status.new(config).call(args)
    end

    desc "commit", "blubb"
    def commit(*args)
      # TODO: fix this in Thor, or here, on top-thor-level:
      if i = args.index("-m")
        args[i+1] = "\"#{args[i+1]}\""
      end

      puts Command::Commit.new(config).call(args)
    end

    desc "ignore", "blubb"
    def ignore(*args)
      puts Command::Ignore.new(config).call(args)
    end

    desc "unignore", "blubb"
    def unignore(*args)
      puts Command::Unignore.new(config).call(args)
    end

    desc "pull", "pull from current branch at origin"
    def pull(*args)
      puts Command::Pull.new(config).call(args)
    end

    desc "push", "push to current branch at origin"
    def push(*args)
      puts Command::Push.new(config).call(args)
    end

  private
    def config
      @config ||= Config.new # TODO: eventually pass path.
    end

    # def self.dynamic_command_class
    #   DynamicCommand
    # end

    #class DynamicCommand < Thor::DynamicCommand
    Thor::DynamicCommand.class_eval do # see https://github.com/erikhuda/thor/pull/358
      def run(app, args)
        puts Command::Dynamic.new(app.send(:config), name).call(args)
      end
    end
  end
end
