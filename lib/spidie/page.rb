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

    property :url, :broken, :visited
    index :url, :broken

    has_n(:links).to(Page)

    def self.retrieve_links_for page
      client = HTTPClient.new
      log "GET request for #{page.url}" 
      result = client.get(page.url)
      log "Status was #{result.status}"
      case result.status
        when 200
          HtmlParser.new(page.url).extract_links(result.content).each do |link_url|
            page.links << retrieve_or_create_page(link_url)
          end
        when 302
          page.url = result.header['Location'].first
          log "Changed url to #{page.url}"
          links = retrieve_links_for page
        else
          page.broken = true
      end
    end
  end
end