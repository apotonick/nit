require 'test_helper'

class NitTest < MiniTest::Spec
  describe "status" do
    it "numbers files to stage" do
      output = nit("status")
      output.must_match "modified: [0]    on_stage.rb"
      output.must_match "modified: [1]    staged.rb"
      output.must_match "[2] brandnew.rb"
      output.must_match "[3] new.rb"
    end
  end

  def nit(args)
    `cd test/dummies/status_1 && ../../../bin/nit #{args}`
  end
end

class LinesTest < MiniTest::Spec
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

  # describe "#find" do
  #   it do
  #     files = []

  #     Nit::Lines.new(output).find do |ln, pat, matches|
  #       files << matches[1].strip
  #     end

  #     files.must_equal(["on_stage.rb", "staged.rb", "brandnew.rb",
  #       "new.rb", "../lib/new.rb"])
  #   end
  # end

  describe "#files" do
    it do
      Nit::Lines.new(output).files.must_equal([
        "on_stage.rb",
        "staged.rb",
        "brandnew.rb",
        "new.rb",
        "../lib/new.rb"])
    end
  end

  #       test status with ../files

  describe "#to_s" do
    let (:output) { "1\n2" }
    it { Nit::Lines.new(output).to_s.must_equal(output) }
  end
end