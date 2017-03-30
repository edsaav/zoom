require "csv" # should this be inside of the class definition?

class LeadsCleaner

  # add an initialize block that sets the csv file as an instance variable
  def initialize(file)
    @needed_columns = [
      "Last Name",
      "First Name",
      "Title",
      "Phone",
      "Email",
      "City",
      "State/Province",
      "Zip/Postal Code",
      "Country",
      "Company",
      "Company domain name",
      "Company phone number"
    ]
    # Define column headers to change, formatted as [old name, correct name]
    @header_corrections = {
      "Last name" => "Last Name",
      "First name" => "First Name",
      "Job title" => "Title",
      "Direct Phone Number" => "Phone",
      "Email address" => "Email",
      "Person City" => "City",
      "Person State" => "State/Province",
      "Person Zip" => "Zip/Postal Code",
      "Company name" => "Company"
    }
    @new_columns = {
      "Conversion Type" => "Sales Generated",
      "Original Lead Source" => "Sales Outbound",
      "Lead Source" => "Sales Outbound"
    }
    CSV::HeaderConverters[:new_headers] = lambda{|header|
      if @header_corrections.keys.include? header
        @header_corrections[header.to_s]
      else
        header
      end
    }
    @leads = CSV.read(file, :headers => true, :header_converters => [:new_headers])
  end

  def remove_columns()
    @leads.headers().each do |header|
      unless @needed_columns.include? header.to_s
        @leads.delete(header.to_s)
      end
    end
  end

  def add_columns()

  end

  def print_leads()
    @leads.each do |lead|
      puts lead["Last name"]
    end
  end

  def leads()
    @leads
  end

  def list_headers()
    @leads.headers().to_s
  end

  def write_new_file()
    CSV.open("clean_list.csv", "w") do |target|
      target << @leads.headers()
      @leads.each do |line|
        target << line
      end
    end
  end

end

# Test code below

lead_list = LeadsCleaner.new("sample.csv")
#puts lead_list.leads.headers()[lead_list.leads.headers().index("First name")]
#lead_list.rename_headers
puts lead_list.list_headers
