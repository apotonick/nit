require 'test_helper'

# this is like an integration test just checking if the "click paths" work.
class NitTest < MiniTest::Spec
  let (:on_stage_line) { "modified:   on_stage.rb  [a]" }

  describe "nit status" do
    it "numbers files to stage" do # TODO: 2BRM, moved to status_test.
      #nit("status").must_match /modified\:\s+on_stage\.rb\s+[a]/
      nit("status").must_match on_stage_line
    end
  end

  describe "nit" do
    it "delegates to status" do
      nit("").must_match on_stage_line
    end
  end

  def nit(args)
    output = ""

    Dir.chdir "test/dummies/" do
      `rm -rf stage`
      `mkdir stage`
      `cp -R git stage/.git`
      `cp files/* stage/`
    end

    Dir.chdir "test/dummies/stage" do
      output = `../../../bin/nit #{args}`
    end

    Dir.chdir "test/dummies/" do
      `rm -rf stage`
    end

    output
  end
end

class DynamicCommandTest < NitTest
  it "evaluates indexes and invokes git command with it" do
    # how to capture STDERR: https://www.ruby-forum.com/topic/1103519#982117
    nit(" checkout e 2>&1").must_match "error: pathspec 'new.rb' did not match any file(s) known to git."
  end
end

class ArbitraryGitCommandsTest < NitTest
  it { nit(" diff b").must_match "a\/staged.rb" }

  it { nit(" diff --raw b").must_equal ":100644 100644 e69de29... 0000000... M\tstaged.rb\n" }

  # it { puts nit(' co -m "fixing it" a') }
end

class NitWithCharIndexerTest < NitTest
  it do
    out = nit(" diff ab")
    out.must_match "a\/staged.rb"
    out.must_match "a\/on_stage.rb"
  end
end