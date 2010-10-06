require 'spidie/store'
require 'nokogiri'

module Spidie
  class Page < Struct.new(:url, :links)
    
    def store
      Store.put self
    end
        
    def self.retrieve url
      page = Page.new
      page.url = url
      page.links = Nokogiri::HTML(open(url)).css('a').map{|link| link['href']}.select{|url| url != nil}
      page
    end
  end
end