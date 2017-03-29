name_file = File.open("../utils/new_names.txt", "r")
name_list = []
name_file.each do |line|
  name_list.push(line.chomp)
end
