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
end