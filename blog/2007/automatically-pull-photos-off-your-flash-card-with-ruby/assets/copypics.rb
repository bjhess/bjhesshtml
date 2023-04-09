# usage ruby copypics.rb [source] [destination]
#
# Copy source .jpg/.jpeg/.raw/.tif/.gif/.png files to destination.  Files are copied into folders
# labeled with the filedate (i.e. 2007-11-01).  All files are stored in the appropriately dated 
# folder.

require 'pathname'
require 'fileutils'
require 'optparse'
require 'ostruct'

# Option parser, thanks to: http://ruby.about.com/od/scripting/a/commandline_arg_2.htm
options = OpenStruct.new
options.verbose = false

opts = OptionParser.new do |opts|
  opts.on("-v", "--verbose", "Display verbose output.") do |v|
    options.verbose = v
  end
  opts.on_tail("-h", "--help", "Show this usage statement") do |h|
    puts opts
  end
end

begin
  opts.parse!(ARGV)
rescue Exception => e
  puts e, "", opts
  exit
end

source = ARGV[0] || "/Volumes/Untitled/"
destination = ARGV[1] || "/Volumes/homewrite/photos/family/full_quality/"

photo_count = 0
Dir["#{source}/**/*.{jpg,JPG,jpeg,JPEG,raw,RAW,tif,TIF,gif,GIF,png,PNG}"].each do |file_name|
  file = Pathname.new(file_name)
  new_dir_name = file.mtime.strftime("%Y-%m-%d")
  destination_dir = destination + new_dir_name
  FileUtils.mkdir destination_dir unless FileTest.exist?(destination_dir)
  new_file_name = file.mtime.strftime("%Y-%m-%d(%H.%M.%S)")
  destination_file = destination_dir + '/' + new_file_name + file.extname.downcase
  FileUtils.copy_file file_name, destination_file
  puts "Photo: [#{file_name}] copied..." if options.verbose
  puts "   To: [#{destination_file}]" if options.verbose
  photo_count += 1
end

puts "PHOTOS COPIED: #{photo_count}"
