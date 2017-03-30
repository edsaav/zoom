require "csv"

class LeadsCleaner

  # add an initialize block that sets the csv file as an instance variable
  def initialize(file)
    @leads = CSV.read(file, headers:true)
    @needed_columns = [
      "Last name",
      "First name",
      "Job title",
      "Direct Phone Number",
      "Email address",
      "Person City",
      "Person State",
      "Person Zip",
      "Country",
      "Company name",
      "Company domain name",
      "Company phone number"
    ]
  end

  def remove_columns()
    @leads.headers().each do |header|
      unless @needed_columns.include? header.to_s
        @leads.delete(header.to_s)
      end
    end
  end

  def print_leads()
    @leads.each do |lead|
      puts lead["Last name"]
    end
  end

  def leads()
    @leads
  end

  def write_new_file()
    CSV.open("clean_list.csv", "w") do |target|
      @leads.each do |line|
        target << line
      end
    end
  end

end

# Test code below

lead_list = LeadsCleaner.new("sample.csv")
lead_list.remove_columns
lead_list.write_new_file
