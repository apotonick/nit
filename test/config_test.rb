require 'test_helper'

class ConfigTest < MiniTest::Spec
  after { subject.send(:file).rm! }
  subject { Nit::Config.new }

  it { subject.indexer.must_equal Nit::Files::CharIndexer }

  it "constantizes #indexer" do
    subject.indexer = "CharIndexer"
    subject.indexer.must_equal Nit::Files::CharIndexer
  end

  it { subject.index_renderer.must_equal Nit::Status::AppendIndexRenderer }
end