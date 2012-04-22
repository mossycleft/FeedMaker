require 'rubygems'
require 'mechanize'
require 'csv'

@agent = Mechanize.new
@date = Time.now.localtime.strftime("%Y-%m-%d")


def main()
  @output_csv = CSV.open("Secondary_Feed#{@date}.csv", 'w')
  @output_csv << ["Title", "Description", "Link", "Price", "Image Link"]
  roll_through  
  
end

def roll_through
  CSV.foreach("Initial_Feed#{@date}.csv", :encoding => 'windows-1251:utf-8') do |row|
        
    title = row[0]
    url   = row[1]
    @page = @agent.get(url)
    pull_price
    pull_description
    output(title, @description, url, @price, "image link")
    end
end

def pull_price
  @price  = @page.parser.xpath("(//div[@class='price-line-2'])[1]").text
end

def pull_description
  @description = @page.parser.xpath("//div[@class='ugc_para']/p[1]").text.capitalize
  # puts page.parser.xpath("//div[@class='ugc_para']/p[1]").to_html
end

def output(title, desc, url, price, image_link)
  puts "title = "       + title
  puts "Description = " + desc
  puts "URL = "         + url
  puts "Price = "       + price
  # @output_csv << [title, url, ]
  
  
end


main()