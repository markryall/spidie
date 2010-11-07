require 'nokogiri'
require 'uri'

module Spidie
  class HtmlParser
    def initialize base
      @base_uri = URI.parse(base)
    end

    def extract_links html
      links = Nokogiri::HTML(html).css('a').map{|link| link['href']}.select{|url| url != nil}
      links = links.reject{|link| link.strip.start_with? "#"}
      links.map do |link|
        link = link.strip.sub(/#.*$/, '')
        if is_link_valid? link
          convert link
        else
          link
        end
      end
    end
    
    def is_link_valid? link
      begin
        URI(link)
        true
      rescue URI::InvalidURIError => e
        false
      end      
    end
    
  private
    def convert link
        uri = URI(link)
        uri = @base_uri+uri if uri.relative?
        uri.to_s
    end
  end
end