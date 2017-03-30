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
      "Company"
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
      @leads.delete(header) unless @needed_columns.include? header
    end
  end

  def add_columns()
    @leads.each do |r|
      @new_columns.each do |column|
        r[column[0]] = column[1]
      end
    end
  end

  def fill_blank_phone_numbers()
    @leads.select {|row| row["Phone"].empty?}.each do |r|
      r["Phone"] = r["Company phone number"]
    end
  end

  def fill_blank_emails()
    @leads.select {|row| row["Email"].empty?}.each do |r| # for each row with a blank "email" field...
      match = @leads.select {|row| r["Company"] == row["Company"]}[0] # find rows with the same "company"...
      eg = EmailGuesser.new() # and guess an email address based on that row's "email"
      r["Email"] = eg.generate_email(r["First Name"], r["Last Name"], match["Email"])
    end
  end

  def write_new_file(name)
    CSV.open(name, "w") do |target|
      target << @leads.headers()
      @leads.each do |line|
        target << line
      end
    end
  end

end
