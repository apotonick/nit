module Nit
  class Command
    def initialize(config)
      @config = config
    end

    def call(args, original=`git status`)
      state = Status::State.new(original, @config)

      indexes, args = process_args(args)

      process(state, indexes, args)
    end

  private
    def process_args(args)
      ArgsProcessor.new(@config).call(args)
    end

    class ArgsProcessor
      def initialize(config)
      end

      def call(thor_args)
        args    = []
        indexes = []

        thor_args.reverse.each do |arg|
          next unless arg.size == 1 or arg =~ /^\w+$/
          indexes << arg
        end


        [indexes.reverse, thor_args-indexes]
      end
    end
  end
end