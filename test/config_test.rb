require 'test_helper'

class ConfigTest < MiniTest::Spec
  after { subject.send(:file).rm! }
  subject { Nit::Config.new }

  it { subject.indexer.must_equal Nit::Files::IntegerIndexer }

  it do
    subject.indexer = Object
    subject.indexer.must_equal Object
  end
end