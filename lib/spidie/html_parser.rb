require 'nokogiri'

module Spidie
  class HtmlParser
    def extract_links html
      Nokogiri::HTML(html).css('a').map{|link| link['href']}.select{|url| url != nil}
    end
  end
end