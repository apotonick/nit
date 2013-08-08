require 'test_helper'

class StateTest < StatusTest
  subject { Nit::Status::State.new(output, []) }
  # describe "#evaluate_index" do
  #   it { subject.evaluate_index(100).must_equal nil }
  #   it { subject.evaluate_index(0).to_s.must_equal "on_stage.rb" }
  # end
end