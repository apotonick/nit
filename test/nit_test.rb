require 'test_helper'

class NitTest < MiniTest::Spec
  describe "nit status" do
    it "numbers files to stage" do # TODO: 2BRM, moved to status_test.
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

class DynamicCommandTest < NitTest
  it "evaluates indexes and invokes git command with it" do
    # how to capture STDERR: https://www.ruby-forum.com/topic/1103519#982117
    nit(" checkout 3 2>&1").must_match "error: pathspec 'new.rb' did not match any file(s) known to git."
  end
end


class IgnoreTest < StatusTest
  let (:config) { Nit::Config.new }

  after do
    config.send(:file).rm!
  end

  it "ignores invalid indexes" do
    Nit::Ignore.new(config).call(output, [100])
    config.ignored_files.must_equal []
  end

  it "what" do
    config.ignored_files.must_equal []

    Nit::Ignore.new(config).call(output, [0,1])

    config.ignored_files.must_equal ["on_stage.rb", "staged.rb"]
  end

  describe "ignore (no arguments)" do
    it "blanks when nothing ignored" do
      Nit::Ignore.new(config).call(output, []).must_equal nil
    end

    it "shows ignored files" do
      Nit::Ignore.new(config).call(output, [1])

      Nit::Ignore.new(config).call(output, []).must_equal <<-EOF
Ignored files:
[0] staged.rb
EOF
# FIXME: why is <<- not working?
    end
  end

  describe "unignore 1 2" do
    it "what" do
      Nit::Ignore.new(config).call(output, [0,1])
      Nit::Unignore.new(config).call(output, [1])
      config.ignored_files.must_equal ["on_stage.rb"]
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
