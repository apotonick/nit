module Nit
  class Dynamic < Command
    def initialize(config, name)
      super(config)
      @command = name
    end

    def process(state, indexes, args)
      `git #{@command} #{args.join(" ")} #{state.files.list(indexes)}`
    end
  end
end