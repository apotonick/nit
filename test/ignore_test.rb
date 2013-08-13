require 'test_helper'

class IgnoreTest < StatusTest
  let (:config) { cfg = Nit::Config.new; cfg.indexer = "IntegerIndexer"; cfg }

  after do
    config.send(:file).rm!
  end

  it "ignores invalid indexes" do
    Nit::Ignore.new(config).call([100], output)
    config.ignored_files.must_equal []
  end

  it "what" do
    config.ignored_files.must_equal []

    Nit::Ignore.new(config).call([0,1], output)

    config.ignored_files.must_equal ["on_stage.rb", "staged.rb"]
  end

  describe "ignore (no arguments)" do
    it "blanks when nothing ignored" do
      Nit::Ignore.new(config).call([], output).must_equal nil
    end

    it "shows ignored files" do
      Nit::Ignore.new(config).call([1], output)

      Nit::Ignore.new(config).call([], output).must_equal <<-EOF
Ignored files:
[0] staged.rb
EOF
# FIXME: why is <<- not working?
    end
  end

  describe "unignore 1 2" do
    it "what" do
      Nit::Ignore.new(config).call([0,1], output)
      Nit::Unignore.new(config).call([1], output)
      config.ignored_files.must_equal ["on_stage.rb"]
    end
  end
end
