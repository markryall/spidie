require 'spidie/store'
require 'nokogiri'

module Spidie
  class Page < Struct.new(:url, :links)
    
    def store
      Store.put self
    end
        
    def self.retrieve url
      links = Nokogiri::HTML(open(url)).css('a').map{|link| link['href']}.select{|url| url != nil}
      Page.new(url, links)
    end
  end
end