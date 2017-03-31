require "leads_cleaner"

describe "LeadsCleaner" do
  let(:leads){LeadsCleaner.new(File.join(File.dirname(__FILE__), "test.csv"), "Edward Saavedra")}

  describe "instantiate" do
    it "creates a new instance of LeadsCleaner" do
      expect(leads).to be_a(LeadsCleaner)
    end
  end

  describe "remove_columns" do
    it "reduces file to 10 columns" do
      expect(leads.remove_columns()[0].length).to eql(10)
    end
  end

  describe "add_columns" do
    it "increases file to 51 columns" do
      expect(leads.add_columns()[0].length).to eql(51)
    end
  end

  # describe "fill_blank_emails" do
  #   it "yields 0 missing emails" do
  #     expect(leads.fill_blank_emails().length).to eql(0)
  #   end
  # end

  # describe "fill_blank_phone_numbers" do
  #   it "yields 0 missing phone numbers" do
  #     expect(leads.fill_blank_phone_numbers().length).to eql(0)
  #   end
  # end
end
