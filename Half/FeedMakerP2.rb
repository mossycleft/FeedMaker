require 'rubygems'
require 'mechanize'
require 'csv'

@agent = Mechanize.new
@date = Time.now.localtime.strftime("%Y-%m-%d")


def main()
  @output_csv = CSV.open("Secondary_Feed#{@date}.csv", 'w')
  @output_csv << ["title", "description", "link", "price", "image link", "id", "product_type", "goole product category", "condition", "brand", "shipping weight", "mpn", "availability"]
  roll_through
end

def roll_through
  product_id_number = 100
  CSV.foreach("Initial_Feed#{@date}.csv", :encoding => 'windows-1251:utf-8') do |row|
    product_id_number += 1 
    product_id = "HALF#{product_id_number}"
    mpn = "SPP#{product_id_number}" 
    title = row[0]
    url   = row[1]
    @page = @agent.get(url)
    product_type = "Halfords > Mobility Aids > Mobility Scooters"
    google_product_category = "Health & Beauty > Health Care > Mobility & Accessibility > Accessibility Equipment > Mobility Scooters"
    condition = "new"
    brand = "Halfords"
    shipping_weight = "10kg" 
    availability = "in stock"
    output(title, product_id, pull_description, url, pull_price, pull_image_link, product_type, google_product_category, condition, brand, shipping_weight, mpn, availability)
    save_image(pull_image_link, product_id, title)
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

def output(title, product_id, desc, url, price, image_link, product_type, google_product_category, condition, brand, shipping_weight, mpn, availability)
  puts "title = "       + title
  puts "Description = " + desc
  puts "URL = "         + url
  puts "Price = "       + price
  puts "Image Link = "  + image_link
  @output_csv << [title, desc, url, price, image_link, product_id, product_type, google_product_category, condition, brand, shipping_weight, mpn, availability]
end

def save_image(image_link, product_id, title)
  @agent.get(image_link).save("images/#{product_id}_#{title}.jpg")
end


main()