require "thor"
require "nit/files"
require "nit/lines"
require "nit/status"
require "nit/commit"
require "nit/config"
require "nit/ignore"



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
    def status
      puts Status.new(config).call
    end

    desc "commit", "blubb"
    def commit(*args)
      puts Commit.new(config).call(`git status`, args)
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
      `git pull origin #{current_branch}`
    end

    desc "push", "push to current branch at origin"
    def push
      `git push origin #{current_branch}`
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
        command = self.name
        state   = Status::State.new(`git status`, app.send(:config))

        puts `git #{command} #{state.files.list(indexes)}`
      end
    end
  end
end
