module Nit
  class Dynamic < Command
    def call(command, args, original=`git status`)
      state = Status::State.new(original, @config)
      `git #{command} #{state.files.list(args)}`
    end
  end
end