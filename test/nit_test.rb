require 'test_helper'

class NitTest < MiniTest::Spec
  describe "status" do
    it "numbers files to stage" do
      output = nit("status")
      puts output
    end
  end

  def nit(args)
    system "bin/nit #{args}"
  end
end