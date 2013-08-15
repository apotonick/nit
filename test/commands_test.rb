require 'test_helper'

class CommandsTest < MiniTest::Spec
  let (:config) { Nit::Config.new }
  let (:cmd_obj) { Nit.const_get(klass).new(config) }
  let (:cmd) { cmd_obj.tap do |obj|
    obj.instance_eval do
      def system(string); string; end
    end
  end }


  describe "push" do
    let (:klass) { "Push" }
    let (:screen) { "* master\n" }

    it { cmd.call([], screen).must_equal("git push origin master ") }
    it { cmd.call(["--tags"], screen).must_equal("git push origin master --tags") }
  end

  describe "puLL" do
    let (:klass) { "Pull" }
    let (:screen) { "* master\n" }

    it { cmd.call([], screen).must_equal("git pull origin master ") }
    it { cmd.call(["--tags"], screen).must_equal("git pull origin master --tags") }
  end

  describe "commit" do
    it "also ignores files when commiting" do
      config.ignored_files = ["new.rb", "brandnew.rb", "staged.rb"] # TODO: make this more generic.

      commit = Nit::Commit.new(config)
      commit.instance_eval do
        def system(command)
          command
        end
      end

      commit.call(["b"], output).must_equal "git add ../lib/new.rb && git commit"
    end
  end
end

class ArgsProcessorTest < MiniTest::Spec
  let (:config) { Nit::Config.new }
  subject { Nit::Command::ArgsProcessor.new(config) }

  it { subject.call([]).must_equal [[], []] }
  it { subject.call(["-a"]).must_equal [[], ["-a"]] }
  it { subject.call(["-a", "-m", '"message"', "abc"]).must_equal [["abc"], ["-a", "-m", '"message"']] }
  it { subject.call(["-m", '"message"', "a", "b"]).must_equal [["a", "b"], ["-m", '"message"']] }
end