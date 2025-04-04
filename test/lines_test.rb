class LinesTest < StatusTest
  describe "#files" do
    it do
      Nit::Lines.new(output).files.map(&:to_s).must_equal([
        "on_stage.rb",
        "staged.rb",
        "brandnew.rb",
        "new.rb",
        "../lib/new.rb",
        "db/migrate/"])
    end
  end

  describe "#to_s" do
    let (:out) { "1\n2" }
    it { Nit::Lines.new(out).to_s.must_equal(out) }
  end

  describe "Line" do
    let (:lines) { Nit::Lines.new("stage\nrocks") }
    subject { lines[0] }

    it { subject.to_s.must_equal "stage" }
    it { subject.delete
         lines.to_s.must_equal "rocks"}
  end
end
