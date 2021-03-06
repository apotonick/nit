require 'test_helper'

class StatusTest < MiniTest::Spec
  let (:config) do
    Nit::Config.new.tap do |cfg| # TODO: test with all combinations?
      cfg.indexer         = "IntegerIndexer"
      cfg.index_renderer  = "PrependIndexRenderer"
    end
  end

  subject { Nit::Command::Status.new(config) }


  describe "indexing" do
    it "numbers files" do
      console = subject.call([], output)
      console.must_match "modified: [0]    on_stage.rb"
      console.must_match "modified: [1]    staged.rb"
      console.must_match "[2] brandnew.rb"
      console.must_match "[3] new.rb"
      console.must_match "[5] db/migrate/"
    end

    it "processes `git status` without #" do
      console = subject.call([], output)
      console.must_match "modified: [0]    on_stage.rb"
      console.must_match "modified: [1]    staged.rb"
      console.must_match "[2] brandnew.rb"
      console.must_match "[3] new.rb"
      console.must_match "[5] db/migrate/"
    end
  end

  describe "char indexing" do
    it "indexes files" do
      config.indexer = "CharIndexer"

      console = subject.call([], output)
      console.must_match "modified: [a]    on_stage.rb"
      console.must_match "modified: [b]    staged.rb"
      console.must_match "[c] brandnew.rb"
      console.must_match "[d] new.rb"
    end
  end

  describe "ignoring" do
    after do
      config.send(:file).rm!
    end

    it "doesn't show ignored files count per default" do
      subject.call([], output).wont_match(/Ignored files:/)
    end

    it "shows ignored files when ignoring" do
      config.ignored_files = ["new.rb", "brandnew.rb", "staged.rb"] # TODO: make this more generic.

      console = subject.call([], output)
      console.must_match "[1] ../lib/new.rb" # this file has a new index since all other ignored.
      console.must_match "Ignored files: 3"
      console.wont_match " staged.rb"
      console.wont_match " new.rb"
      console.wont_match " brandnew.rb"
      console.must_match " ../lib/new.rb"
    end
  end
end