names = File.open("names.txt")
new_names = File.open("new_names.txt", "w")

names.each do |line|
  new_names.puts line.split(" ")[0].downcase
end
