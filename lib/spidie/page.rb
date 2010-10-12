require 'spidie/store'
require 'nokogiri'
require 'httpclient'
require 'spidie/html_parser'

module Spidie
  class Page 
    attr_reader :url
    attr_accessor :links, :broken

    def initialize url, broken=false
      @url, @broken = url, broken
      @links = []
    end

    def broken?
      @broken
    end
    
    def store
      Store.put self
    end

    def self.retrieve url
      client = HTTPClient.new
      result = client.get(url)

      page = Page.new(url)
      page.broken = true if result.status != 200
      page.links = HtmlParser.extract_links(result.content).map{|link| Page.new link } unless page.broken
      page
    end
  end
end