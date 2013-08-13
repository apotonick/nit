require "thor"
require "nit/files"
require "nit/lines"
require "nit/command"
require "nit/status"
require "nit/commit"
require "nit/config"
require "nit/ignore"
require "nit/push"
require "nit/pull"




# TODO:
# * diff workflow: going through changed files, adding them while reading!
# * nit unstage => git reset HEAD
# * nit ignore (save time and last changed!)
# * nit unignore
# * nit co -a => git commit -a
# * nit co -m ".." abc
# * nit co 1<tab> => filename

module Nit
  class App < Thor
    include Actions

    default_command(:status)

    desc "status", "bla"
    def status(*args)
      puts Status.new(config).call(args)
    end

    desc "commit", "blubb"
    def commit(*args)
      puts Commit.new(config).call(args)
    end

    desc "ignore", "blubb"
    def ignore(*args)
      puts Ignore.new(config).call(`git status`, args)
    end

    desc "unignore", "blubb"
    def unignore(*args)
      puts Unignore.new(config).call(`git status`, args)
    end


    desc "pull", "pull from current branch at origin"
    def pull
      puts Nit::Pull.new(config).call(args)
    end

    desc "push", "push to current branch at origin"
    def push(*args)
      puts Nit::Push.new(config).call(args)
    end

  private
    def current_branch
      output = `git branch`
      branch = output.match(/\* (.+)/)[1].strip
    end

    def config
      @config ||= Config.new # TODO: eventually pass path.
    end

    # def self.dynamic_command_class
    #   DynamicCommand
    # end

    #class DynamicCommand < Thor::DynamicCommand
    Thor::DynamicCommand.class_eval do # see https://github.com/erikhuda/thor/pull/358
      def run(app, indexes)
        #raise "dynamic: #{indexes.inspect}"
        command = self.name
        state   = Status::State.new(`git status`, app.send(:config))

        puts `git #{command} #{state.files.list(indexes)}`
      end
    end
  end
end
