require 'spidie/store'
require 'spidie/logger'
require 'nokogiri'
require 'httpclient'
require 'spidie/html_parser'
require 'neo4j'

module Spidie
  class Page
    include Logger
    include Store
    include Neo4j::NodeMixin

    property :url, :broken, :visited
    index :url, :broken

    has_n(:links).to(Page)
    
    def init_node(params)
      self[:url] = params[:url]
      self[:visited] = false
      self[:broken] = false
      self[:visited] = params[:visited] if params[:visitied] 
      self[:broken] = params[:broken] if params[:broken] 
    end

    def get_content_and_populate_links
      client = HTTPClient.new
      
      result = nil
      begin
        log "GET request for #{self.url}" 
        result = client.get(self.url)
        log "Status was #{result.status}"
      rescue Errno::ECONNREFUSED => e
        client.head("http://www.google.com")
        log e.message
        self.broken = true
      end
      
      if result
        case result.status 
          when 200
            populate_links(result.content)
          when 302
            self.url = result.header['Location'].first
            log "Changed url to #{self.url}"
            links = self.get_and_populate_links
          else
            self.broken = true
        end
      end
      self.visited = true
    end
    
    def populate_links html_content
      HtmlParser.new(self.url).extract_links(html_content).each do |link_url|
        self.links << retrieve_or_create_page(link_url)
      end
    end
    
  end
end