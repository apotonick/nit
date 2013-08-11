require 'test_helper'

class ConfigTest < MiniTest::Spec
  after { subject.send(:file).rm! }
  subject { Nit::Config.new }

  it { subject.indexer.must_equal Nit::Files::IntegerIndexer }

  it "constantizes #indexer" do
    subject.indexer = "CharIndexer"
    subject.indexer.must_equal Nit::Files::CharIndexer
  end
end