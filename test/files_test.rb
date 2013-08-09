require 'test_helper'

class NitFileTest < MiniTest::Spec
  it { Nit::File.new("new.rb", "<line 1>").to_s.must_equal "new.rb" }
end

class FilesTest < MiniTest::Spec
  subject { Nit::Files.new(["on_stage.rb", "stage.rb", "stagedive.mk"]) }

  describe "#[]" do # evaluate_index
    it { subject[100].must_equal nil }
    it { subject[0].to_s.must_equal "on_stage.rb" }
    it { subject["0"].to_s.must_equal "on_stage.rb" }
  end

  describe "#index" do
    it { subject.index("on_stage.rb").must_equal 0 }
    #it { subject.index(Nit::File.new("on_stage.rb", "<line 1>")).must_equal 0 }
  end

  # methods that should be in a separate class, like CliIndexer or so.
  describe "#evaluate" do
    it { subject.evaluate([1,2]).must_equal ["stage.rb", "stagedive.mk"] }
  end

  describe "#list" do
    it { subject.list([0, 1]).must_equal "on_stage.rb stage.rb" }
  end
end