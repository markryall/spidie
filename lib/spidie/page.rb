require 'spidie/store'
require 'spidie/logger'
require 'nokogiri'
require 'httpclient'
require 'spidie/html_parser'
require 'neo4j'

module Spidie
  class Page
    extend Logger
    extend Store
    include Neo4j::NodeMixin

    property :url
    property :broken
    index :url, :broken

    has_n(:links).to(Page)

    def self.retrieve_links_for page
      client = HTTPClient.new
      log { "GET request for #{page.url}" }
      result = client.get(page.url)
      log { "Status was #{result.status}" }
      links = []
      case result.status
        when 200
          links = HtmlParser.new(page.url).extract_links(result.content)
        when 302
          page.url = result.header['Location'].first
          links = retrieve_links_for page
        else
          page.broken = true
      end
      links
    end
  end
end