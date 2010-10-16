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

      page.broken = true unless result.status == 200
      HtmlParser.new(page.url).extract_links(result.content).map{|link| create_page link } unless page.broken
    end
  end
end