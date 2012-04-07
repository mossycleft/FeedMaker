require 'rubygems'
require 'mechanize'
require 'csv'

@agent = Mechanize.new
@date = Time.now.localtime.strftime("%Y-%m-%d")

def main()
  pull_attrb("http://www.lamuscle.com")
  
end

def pull_attrb(url)
  page = @agent.get(url)

  puts "Working..."
  page.links.each do |link|
    if is_product_link(link.uri)
      puts link.text    
      puts link.uri
      puts "\n"
    else
      puts "Not Product Link"
      puts "\n"
    end
  end
  
  # @output_csv = CSV.open("Feed_URLs_#{@date}.csv", 'w')
  #   @output_csv << ["URL", "Title", "Description", "Price"]
  
end

def is_product_link(url)
  product_link = "products/"
  not url.to_s.scan(/#{product_link}/i).empty?
end

def save_attrb(url, title, desc, price)
  @output_csv << [url, title, desc, price]
  
  
end

main()

