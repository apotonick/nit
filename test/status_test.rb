require 'test_helper'

class StatusTest < MiniTest::Spec
  let (:config) { Nit::Config.new }
  let (:output) do <<-EOF
    # On branch master
    # Changes not staged for commit:
    #   (use "git add <file>..." to update what will be committed)
    #   (use "git checkout -- <file>..." to discard changes in working directory)
    #
    #\tmodified:   on_stage.rb
    #\tmodified:   staged.rb
    #
    # Untracked files:
    #   (use "git add <file>..." to include in what will be committed)
    #
    #\tbrandnew.rb
    #\tnew.rb
    #\t../lib/new.rb
    no changes added to commit (use "git add" and/or "git commit -a")
    EOF
  end
  subject { Nit::Status.new(config) }


  describe "indexing" do
    it "numbers files" do
      console = subject.call(output)
      console.must_match "modified: [0]    on_stage.rb"
      console.must_match "modified: [1]    staged.rb"
      console.must_match "[2] brandnew.rb"
      console.must_match "[3] new.rb"
    end
  end

  describe "ignoring" do
    after do
      config.rm_config
    end

    it "doesn't show ignored files count per default" do
      subject.call(output).wont_match(/Ignored files:/)
    end

    it "shows ignored files when ignoring" do
      config.add_ignored_files("new.rb", "brandnew.rb", "staged.rb") # TODO: make this more generic.

      console = subject.call(output)
      console.must_match "[1] ../lib/new.rb" # this file has a new index since all other ignored.
      console.must_match "Ignored files: 3"
      console.wont_match " staged.rb"
      console.wont_match " new.rb"
      console.wont_match " brandnew.rb"
      console.must_match " ../lib/new.rb"
    end

    it "also ignores files when commiting" do
      config.add_ignored_files("new.rb", "brandnew.rb", "staged.rb") # TODO: make this more generic.

      commit = Nit::Commit.new(config)
      commit.instance_eval do
        def system(command)
          command
        end
      end

      commit.call(output, [1]).must_equal "git add ../lib/new.rb && git commit"
    end
  end
end