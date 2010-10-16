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

      links = []
      if result.status == 200
        links = HtmlParser.new(page.url).extract_links(result.content)
      else
        page.broken = true
      end
      links
    end
  end
end