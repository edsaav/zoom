require_relative "lib/leads_cleaner"

class Zoom
  def initialize()
    @user_name = ""
    @intro = <<-HERE

  ############################################################################
  ############################################################################
  ##                                                                        ##
  ##                          LEAD LIST CLEANER                             ##
  ##                                                                        ##
  ############################################################################
  ############################################################################

  created March 2017 by Edward Saavedra


  Welcome to the Zinc lead list cleaner. Please follow the upcoming prompts to
  clean up a CSV file and prepare it for uploading into SalesForce.

  First, please move the CSV file that you would like to clean into the folder
  entitled PUT_YOUR_FILES_HERE.

    HERE
  end

  def open_program()
    puts @intro
    puts "What is your full name?"
    @user_name = gets.chomp
    puts "\nGreat, thanks #{@user_name.split(" ")[0]}! Now let's get started."
  end

  def process(file)
    file.add_columns
    file.fill_blank_phone_numbers
    file.fill_blank_emails
    file.remove_columns
  end

  def create_new_file(f)
    puts "What would you like the new file to be called?"
    new_file_name = gets.chomp

    puts "Creating new file '#{new_file_name}'."
    f.write_new_file("CLEANED_FILES/" + new_file_name)

    puts "Done! You can now find #{new_file_name} in the CLEANED_FILES folder."
  end

  def clean_file()
    puts "What is the full name of the file you would like to clean?"
    file_name = gets.chomp
    lead_list = LeadsCleaner.new("PUT_YOUR_FILES_HERE/" + file_name, "Edward Saavedra")
    puts "Thanks, your file is now being cleaned."
    process(lead_list)
    create_new_file(lead_list)
  end
end

z = Zoom.new
z.open_program
z.clean_file
