require 'spidie/store'
require 'nokogiri'
require 'httpclient'
require 'spidie/html_parser'


module Spidie
  class Page 
    attr_reader :url, :links
    
    def initialize(url, links)
      @url= url
      @links = links || []
    end
    
    def store
      Store.put self
    end
    
    def broken?
      @links.empty? 
    end
        
    def self.retrieve url
      client = HTTPClient.new
      result = client.get(url)
      
      links = HtmlParser.extract_links result.content
      Page.new(url, links)
    end
  end
end