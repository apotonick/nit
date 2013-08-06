require 'test_helper'

class NitTest < MiniTest::Spec
  describe "nit status" do
    it "numbers files to stage" do
      output = nit("status")
      output.must_match "modified: [0]    on_stage.rb"
      output.must_match "modified: [1]    staged.rb"
      output.must_match "[2] brandnew.rb"
      output.must_match "[3] new.rb"
    end
  end

  describe "nit" do
    it "delegates to status" do
      output = nit("").must_match "modified: [0]    on_stage.rb"
    end
  end

  def nit(args)
    `cd test/dummies/status_1 && ../../../bin/nit #{args}`
  end
end

class StatusTest < MiniTest::Spec
  let (:config) { Nit::Config.new }
  let (:output) do <<EOF
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

  describe "ignoring" do
    after do
      config.rm_config
    end

    it "doesn't show ignored files count per default" do
      Nit::Status.new(config).call(output).wont_match(/Ignored files:/)
    end

    it "shows ignored files when ignoring" do
      config.add_ignored_files("new.rb", "brandnew.rb", "staged.rb") # TODO: make this more generic.

      console = Nit::Status.new(config).call(output)
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

class LinesTest < StatusTest
  describe "#files" do
    it do
      Nit::Lines.new(output).files.map(&:to_s).must_equal([
        "on_stage.rb",
        "staged.rb",
        "brandnew.rb",
        "new.rb",
        "../lib/new.rb"])
    end
  end

  describe "#to_s" do
    let (:output) { "1\n2" }
    it { Nit::Lines.new(output).to_s.must_equal(output) }
  end

  describe "Line" do
    let (:lines) { Nit::Lines.new("stage\nrocks") }
    subject { lines[0] }

    it { subject.to_s.must_equal "stage" }
    it { subject.delete
         lines.to_s.must_equal "rocks"}
  end
end

class NitFileTest < MiniTest::Spec
  it { Nit::File.new("new.rb", "<line 1>").to_s.must_equal "new.rb" }
end