require 'spidie/store'
require 'nokogiri'
require 'httpclient'
require 'spidie/html_parser'
require 'neo4j'

module Spidie
  class Page
    extend Store
    include Neo4j::NodeMixin

    property :url
    property :broken
    index :url, :broken

    has_n(:links).to(Page)

    def self.retrieve_links_for page
      client = HTTPClient.new
      result = client.get(page.url)

      if result.status == 200
        HtmlParser.new(page.url).extract_links(result.content).each do |link|
          page.links << retrieve_or_create_page(link)
        end
      else
        page.broken = true
      end
    end
  end
end