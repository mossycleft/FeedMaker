require 'rubygems'
require 'mechanize'
require 'csv'

@agent = Mechanize.new
@date = Time.now.localtime.strftime("%Y-%m-%d")


def main()
  @output_csv = CSV.open("Secondary_Feed#{@date}.csv", 'w')
  @output_csv << ["Title", "Description", "Link", "Price", "Image Link", "Product ID"]
  roll_through  
  
end

def roll_through
  product_id = 0
  CSV.foreach("Initial_Feed#{@date}.csv", :encoding => 'windows-1251:utf-8') do |row|
    product_id = product_id + 1    
    title = row[0]
    url   = row[1]
    @page = @agent.get(url)
    pull_price
    pull_description
    pull_image_link
    output(title, product_id, pull_description, url, pull_price, pull_image_link)
    save_image(pull_image_link, product_id)
    end
end

def pull_image_link
  image_link = @page.parser.xpath("(//div[@class='jqzoom'])[1]/img").to_html
  image_link = image_link.to_s.gsub(/<img id="fullImage" src="/,"")
  image_link = image_link.to_s.gsub(/" alt=".+/,"")
  return image_link  
end

def pull_price
  price  = @page.parser.xpath("(//div[@class='total'])[1]").text
  price = price.strip
  return price

end

def pull_description
  description = @page.parser.xpath("(//div[@class='fontsizer']/ul)[1]").to_html
  description = description + @page.parser.xpath("(//div[@class='fontsizer']/p)[2]").to_html
  description = description.gsub(/<\/?[^>]*>/, '').gsub(/\n\n+/, "\n").gsub(/^\n|\n$/, '')
  # puts page.parser.xpath("//div[@class='ugc_para']/p[1]").to_html
  return description
end

def output(title, product_id, desc, url, price, image_link)
  puts "title = "       + title
  puts "Description = " + desc
  puts "URL = "         + url
  puts "Price = "       + price
  puts "Image Link = "  + image_link
  @output_csv << [title, desc, url, price, image_link]
end

def save_image(image_link, product_id)
  @agent.get(image_link).save("images/#{product_id}.jpg")
  # @agent.get(image_link).class.save  #=> Mechanize::File
  
end


main()