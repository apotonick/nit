require 'test_helper'

class IgnoreTest < StatusTest
  let (:config) { Nit::Config.new }
  after do
    config.send(:file).rm!
  end

  it "ignores invalid indexes" do
    Nit::Command::Ignore.new(config).call(["z"], output)
    config.ignored_files.must_equal []
  end

  it "what" do
    config.ignored_files.must_equal []

    Nit::Command::Ignore.new(config).call(["ab"], output)

    config.ignored_files.must_equal ["on_stage.rb", "staged.rb"]
  end

  describe "ignore (no arguments)" do
    it "blanks when nothing ignored" do
      Nit::Command::Ignore.new(config).call([], output).must_equal nil
    end

    it "shows ignored files" do
      Nit::Command::Ignore.new(config).call(["b"], output)

      Nit::Command::Ignore.new(config).call([], output).must_equal <<-EOF
Ignored files:
[a] staged.rb
EOF
# FIXME: why is <<- not working?
    end
  end

  describe "unignore 1 2" do
    it "what" do
      Nit::Command::Ignore.new(config).call(["ab"], output)
      Nit::Command::Unignore.new(config).call(["b"], output)
      config.ignored_files.must_equal ["on_stage.rb"]
    end
  end
end
