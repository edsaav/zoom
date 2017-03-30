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

  ############################################################################

    HERE
  end

  def program_loop()
    open_program
    while true
      clean_file
      puts "Would you like to clean another file? Y/N"
      break unless ["Yes", "yes", "Y", "y", "yeah", "yup", "sure"].include? gets.chomp
    end
  end

  private

  def open_program()
    puts @intro
    puts "What is your full name?"
    while true
      @user_name = gets.chomp
      break if @user_name.split(" ").length == 2
      puts "Oops! Please enter your full first and last name."
    end
    puts "\nGreat, thanks #{@user_name.split(" ")[0]}! Now let's get started."
  end

  def process(f)
    f.add_columns
    f.fill_blank_phone_numbers
    f.fill_blank_emails
    f.remove_columns
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
    while true
      f = "PUT_YOUR_FILES_HERE/" + gets.chomp
      break if File.exist?(f) && File.extname(f) == ".csv"
      puts "Hm. I can't find that file. Please confirm that:"
      puts "1. You entered the .csv extention of the file"
      puts "2. #{f} is a .csv file in the PUT_YOUR_FILES_HERE folder"
      puts "\nPlease enter the name of the file again:"
    end
    lead_list = LeadsCleaner.new(f, @user_name)
    puts "Thanks, your file is now being cleaned."
    process(lead_list)
    create_new_file(lead_list)
  end
end

Zoom.new.program_loop
