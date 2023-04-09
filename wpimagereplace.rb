# ChatGPT helped me write this
# Call: ruby wpimagereplace.rb ~/Sites/bjhesshtml/blog/2007
require 'fileutils'

def replace_image_paths(file_path)
  # Read in the file
  file = File.read(file_path)

  # Replace the image paths
  updated_file = file.gsub(/<img src=\"\.\.\/\.\.\/bjhessblog\/wp-content\/uploads\/\d+\/\d+\/(.*?)\">/, '<img src="images/\1">')

  # Write the updated file back out
  File.write(file_path, updated_file)
end

def process_directory(dir_path)
  # Loop through all the files in the directory
  Dir.foreach(dir_path) do |filename|
    # Ignore files starting with a dot (hidden files)
    next if filename.start_with?('.')

    # Construct the full file path
    file_path = File.join(dir_path, filename)

    if File.directory?(file_path)
      # Recursively process subdirectories
      process_directory(file_path)
    elsif File.file?(file_path) && File.extname(file_path) == '.html'
      # Process HTML files
      replace_image_paths(file_path)
    end
  end
end

# Read the directory path from the command line argument
dir_path = ARGV[0]

# Start processing at the specified directory
process_directory(dir_path)
