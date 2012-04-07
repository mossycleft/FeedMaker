require 'rubygems'
require 'mechanize'
require 'csv'

@agent = Mechanize.new
@date = Time.now.localtime.strftime("%Y-%m-%d")
# Things to change
@page_with_links = "http://www.lamuscle.com"
@product_link = "products/"


def main()
  @output_csv = CSV.open("Initial_Feed#{@date}.csv", 'w')
  pull_attrb(@page_with_links) 
end

def pull_attrb(url)
  page = @agent.get(url)

  puts "Working..."
  page.links.each do |link|
    if is_product_link(link.uri)
      puts link.text    
      puts link.uri
      puts "\n"
      save_attrb(link.text, link.uri)
    else
      puts "Not Product Link"
      puts "\n"
    end
  end 
end

def is_product_link(url)
  not url.to_s.scan(/#{@product_link}/i).empty?
end

def save_attrb(title, url)
  full_url = @page_with_links + url.to_s
  @output_csv << [title, full_url]
  
  
end

main()

