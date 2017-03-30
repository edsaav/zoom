##### Operation order #####
## 1. Rename columns - does not need to be explicitely called
## 2. Add columns
## 3. Fill in phone numbers
## 4. Fill in emails
## 5. Remove extra columns

require_relative "lib/leads_cleaner"

intro = <<-HERE

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

#### Start of script steps ####

puts intro
puts "What is your full name?"
user_name = gets.chomp
puts "\nGreat, thanks #{user_name.split(" ")[0]}! Now let's get started."
puts "What is the full name of the file you would like to clean?"
file_name = gets.chomp
lead_list = LeadsCleaner.new("PUT_YOUR_FILES_HERE/" + file_name, "Edward Saavedra")
puts "Thanks, your file is now being cleaned."

lead_list.add_columns
lead_list.fill_blank_phone_numbers
lead_list.fill_blank_emails
lead_list.remove_columns

puts "What would you like the new file to be called?"
new_file_name = gets.chomp

puts "Creating new file '#{new_file_name}'."
lead_list.write_new_file("CLEANED_FILES/" + new_file_name)

puts "Done! You can now find #{new_file_name} in the CLEANED_FILES folder."
