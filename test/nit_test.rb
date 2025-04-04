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

      yield if block_given?
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
    assert_equal nit(" checkout e 2>&1"), "error: pathspec 'new.rb' did not match any file(s) known to git

"
  end
end

class ArbitraryGitCommandsTest < NitTest
  it { nit(" diff b").must_match "a\/staged.rb" }

  it { nit(" diff --raw b").must_equal ":100644 100644 e69de29 0000000 M\tstaged.rb\n" }

  # commit:
  it "allows strings after -m" do # TODO: implement that for all commands?
    output = nit(' co -m "fixing it" a')
    output.must_match "] fixing it\n"
    output.must_match "1 file changed" # TODO: check if correct file was commited.
  end

  # FIXME: with one changed, one new file!!!
  it "what" do
    output = nit(' ') do
      `touch stage/new_file`
      `cd stage && git add stage/new_file`
    end
    puts output
    assert_equal output, "] fixing it\n"
  end




  # it "allows -m after file indices" do
  #   output = nit(' co ab -m add something 4 u')
  #   puts output
  #   output.must_match "] add #999\n"
  #   output.must_match "2 files changed" # TODO: check if correct file was commited.
  # end
end

class NitWithCharIndexerTest < NitTest
  it do
    out = nit(" diff ab")
    out.must_match "a\/staged.rb"
    out.must_match "a\/on_stage.rb"
  end
end
