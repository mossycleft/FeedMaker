require 'rubygems'
require 'mechanize'
require 'csv'

@agent = Mechanize.new
@date = Time.now.localtime.strftime("%Y-%m-%d")
# Things to change
@domain = "http://www.halfords.com"
@page_with_links = "http://www.halfords.com/webapp/wcs/stores/servlet/categorydisplay_storeId_10001_catalogId_10151_categoryId_211570_langId_-1"
@product_link = "productId_"


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
  clean_title = title.to_s.gsub(/\A(\s+)/,"")
  clean_title = clean_title.to_s.gsub(/(\s+)\z/,"")
  @output_csv << [clean_title, url]
  
  
end

main()

