module Nit
  class Command
    class Push < Command
      def call(args, original=`git branch`)
        branch = current_branch_for(original)

        system("git #{command} origin #{branch} #{args.join(" ")}")
      end

    private
      def command
        "push"
      end

      def current_branch_for(screen)
        screen.match(/\* (.+)/)[1].strip
      end
    end
  end
end