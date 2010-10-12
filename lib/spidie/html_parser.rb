require 'nokogiri'
require 'uri'

module Spidie
  class HtmlParser
    def initialize base
      @base_uri = URI.parse(base)
    end

    def extract_links html
      links = Nokogiri::HTML(html).css('a').map{|link| link['href']}.select{|url| url != nil}
      links.map {|link| convert link}
    end
  private
    def convert link
      uri = URI(link)
      uri = @base_uri+uri if uri.relative?
      uri.to_s
    end
  end
end