require 'nokogiri'
require 'open-uri'

module Spidie
  class LinkExtractor
    def initialize url
      @url = url
    end

    def each
      Nokogiri::HTML(open(@url)).css('a').each { |link| yield link['href'] if link['href'] }
    end
  end
end