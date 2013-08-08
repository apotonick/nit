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

class DynamicCommandTest < NitTest
  it "evaluates indexes and invokes git command with it" do
    # how to capture STDERR: https://www.ruby-forum.com/topic/1103519#982117
    nit(" checkout 3 2>&1").must_match "error: pathspec 'new.rb' did not match any file(s) known to git."
  end
end


class IgnoreTest < StatusTest
  let (:config) { Nit::Config.new }

  after do
    config.rm_config
  end

  it "what" do
    config.ignored_files.must_equal []

    Nit::Ignore.new(config).call(output, [0,1])

    config.ignored_files.must_equal ["on_stage.rb", "staged.rb"]
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