#! /usr/bin/env ruby
# gem install nokogiri
# gem install titleize
#
# Helpful:
#   http://ruby.bastardsbook.com/chapters/html-parsing/
#   https://gist.github.com/carolineartz/10276637 (Nokogiri cheat sheet)
#   https://github.com/sparklemotion/nokogiri/wiki/Cheat-sheet
#
# This ran in the prior blog's HTML export's blog directory. Exported like this:
# $ brew install wget
# $ wget \
#      --recursive \
#      --page-requisites \
#      --html-extension \
#      --convert-links \
#      --domains bjhess.com \
#          bjhess.com
#
# It also needs an template.html file representing the new blog markup.
# It would creates a directory (@convert) and a table of contents (@toc.html).
#

require 'nokogiri'
require 'date'
require 'titleize'

print "What do your directories start with? "
directory_start = gets.strip
if directory_start.strip.empty?
  puts "Empty string not allowed!"
  exit
end
puts "Converting directories starting with: #{directory_start}"

directories = Dir.glob("./#{directory_start}*")
template_doc = File.open("template.html") { |f| Nokogiri::HTML5(f) }

posts = {
  "2022": [],
  "2021": [],
  "2020": [],
  "2019": [],
  "2018": [],
  "2017": [],
  "2016": [],
  "2015": [],
  "2014": [],
  "2013": [],
  "2012": [],
  "2011": [],
  "2010": [],
  "2009": [],
  "2008": [],
  "2007": [],
  "2006": [],
  "2005": [],
  "2004": [],
}

directories.each do |directory|
  puts "  Converting #{directory}"

  # directories with year names need processed yet
  doc = File.open("#{directory}/index.html") { |f| Nokogiri::HTML5(f) } rescue next
  begin
    post_date = Date.parse(doc.css('#content .article_footer .date').first.content.strip)
  rescue
    puts "MANUALLY convert #{directory}"
    next
  end
  # puts post_date

  post_title = doc.css('#content h1 a').first.content.strip.titleize
  # puts post_title

  post_content = ""

  # THIS WAS MY FIRST TRY
  # https://stackoverflow.com/questions/21218824/nokogiri-node-set
  # content = doc.xpath('//section/div/div[1]/preceding::node()[ count( . | //h1[1]/following::node()) = count(//h1[1]/following::node()) ]').each do |link|
  #   # The xpath lookup doubles each entry: one as an element/node, one as the text within it.
  #   # Skip text.
  #   next if link.is_a?(Nokogiri::XML::Text)
  #   # puts link
  #   # puts link.to_html
  #   # #serialize retains the HTML tags
  #   post_content += link.to_html
  # end

  # Traverse doc
  content_element = doc.css('#content').first
  content_element.children.each do |element|
    next if element.matches?('h1') ||
              element.matches?('.article_footer')

    post_content += element.to_html
  end
  # puts post_content

  # Write new directories and HTML file.
  conversion_directory_name = "@convert"
  Dir.mkdir(conversion_directory_name) unless File.exists?(conversion_directory_name)
  year_directory_name = "#{conversion_directory_name}/#{post_date.year}"
  Dir.mkdir(year_directory_name) unless File.exists?(year_directory_name)
  post_directory_name = "#{year_directory_name}/#{directory.gsub('_', '-')}"
  Dir.mkdir(post_directory_name) unless File.exists?(post_directory_name)

  new_doc = template_doc.serialize
  new_doc.gsub!('POST-TITLE', post_title)
  new_doc.gsub!('POST-CONTENT', post_content)
  new_doc.gsub!('POST-DATE', post_date.strftime('%B %-d, %Y'))

  File.write("#{post_directory_name}/index.html", new_doc)

  # Collect post meta information for table of contents.
  posts[post_date.year.to_s.to_sym] << [post_date, directory.gsub('_', '-').gsub('./', ''), post_title]
end

puts "Creating table of contents"
posts.each do |key, value|
  # puts key
  # puts value.class.name
  # puts value.first.class.name
  # puts posts[key].class.name
  posts[key] = value.sort { |a, b| b <=> a }
end

toc_doc = %{\n\n\n<div class="blog-list">\n}
posts.each do |key, value|
  toc_doc += %{  <h2 class="year-head">#{key}</h2>\n}
  toc_doc += %{  <ul>\n}
  posts[key].each do |post_meta|
    toc_doc += %{    <li>\n}
    toc_doc += %{      <time datetime"#{post_meta[0].strftime("%Y-%m-%d")}T00:00:00-05:00">#{post_meta[0].strftime("%b %-d")}</time>\n}
    toc_doc += %{      <a href="/blog/#{post_meta[0].strftime("%Y")}/#{post_meta[1]}/">#{post_meta[2]}</a>\n}
    toc_doc += %{    </li>\n}
  end
  toc_doc += %{  </ul>\n}
end
toc_doc += %{</div>\n\n}

# puts posts
# puts toc_doc

File.write("@toc.html", toc_doc)
