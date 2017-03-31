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
      # expect(leads.remove_columns()[0].length).to eql(10)
      leads.remove_columns()
      expect(leads.headers).to eql(["Last Name", "First Name", "Title", "Phone", "Email", "City", "State/Province", "Zip/Postal Code", "Country", "Company"])
    end
  end

  describe "add_columns" do
    it "increases file to 51 columns" do
      leads.add_columns()
      expect(leads.headers()).to include("Conversion Type", "Original Lead Source", "Lead Source", "Owner", "Status")
    end
  end

  describe "fill_blank_emails" do
    it "yields 0 missing emails" do
      leads.fill_blank_emails
      expect(leads.content.select {|row| row["Email"].to_s.empty?}.to_a.length).to eql(0)
    end
  end

  describe "fill_blank_phone_numbers" do
    it "yields 0 missing phone numbers" do
      leads.fill_blank_phone_numbers
      expect(leads.content.select {|row| row["Phone"].to_s.empty?}.to_a.length).to eql(0)
    end
  end
end
