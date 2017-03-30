require "csv" # should this be inside of the class definition?
require_relative "email_guesser"

class LeadsCleaner

  # add an initialize block that sets the csv file as an instance variable
  def initialize(file, owner)
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
    # Define columns to add, formatted as [header, default field value]
    @new_columns = [
      ["Conversion Type", "Sales Generated"],
      ["Original Lead Source", "Sales Outbound"],
      ["Lead Source", "Sales Outbound"],
      ["Record Owner", owner],
      ["Status", "Untouched"]
    ]
    # Define block to edit column headers
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
    @leads.each do |row|
      @new_columns.each do |column|
        row[column[0]] = column[1]
      end
    end
  end

  def fill_blank_phone_numbers()
    @leads.each do |row|
      if row["Phone"].empty?
        row["Phone"] = row["Company phone number"]
      end
    end
  end

  def fill_blank_emails()
    @leads.each do |row|
      if row["Email"].empty?
        domain = row["Company domain name"]
        @leads.each do |r|
          if r["Company domain name"] == domain
            e = EmailGuesser.new()
            row["Email"] = e.generate_email(row["First Name"], row["Last Name"], r["Email"])
          end
        end
      end
    end
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

#### Operation order ####
# 1. Rename columns - does not need to be explicitely called
# 2. Add columns
# 3. Fill in phone numbers
# 4. Fill in emails
# 5. Remove extra columns

lead_list = LeadsCleaner.new("sample.csv", "Edward Saavedra")


lead_list.add_columns
lead_list.fill_blank_phone_numbers
lead_list.fill_blank_emails
lead_list.remove_columns
lead_list.write_new_file
