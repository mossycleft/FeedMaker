require 'rubygems'
require 'mechanize'
require 'csv'

@agent = Mechanize.new

def main()
  page = @agent.get(url)
    
end


main()

