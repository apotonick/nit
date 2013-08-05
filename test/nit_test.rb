require 'test_helper'

class NitTest < MiniTest::Spec
  describe "status" do
    it "numbers files to stage" do
      output = nit("status")
      #puts output
      output.must_match "modified: [0]    on_stage.rb"
      output.must_match "modified: [1]    staged.rb"
      output.must_match "[2] brandnew.rb"
      output.must_match "[3] new.rb"
      #puts output
    end
  end

  def nit(args)
    `cd test/dummies/status_1 && ../../../bin/nit #{args}`
  end
end