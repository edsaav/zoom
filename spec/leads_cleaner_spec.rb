require "leads_cleaner"

describe "LeadsCleaner" do
  describe ".remove_columns" do
    context "given no input" do
      it "returns nil" do
        expect(LeadsCleaner.remove_columns("")).to eql(nil)
      end
    end
    
  end

end
