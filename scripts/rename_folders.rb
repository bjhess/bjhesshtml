#! ruby

puts "Processing files"
Dir.glob('blog/2021/*').sort.each do |folder_name|
  puts "Renaming #{folder_name}"
  new_folder_name = folder_name.gsub('_', '-')
  File.rename(folder_name, new_folder_name)
  puts "Rename from " + folder_name + " to " + new_folder_name
end
