require 'neo4j'

module Spidie
  class PageNode
    include Neo4j::NodeMixin

    def self.create_from page
      self.new :url => page.url, :broken => page.broken
    end

    property :url
    property :broken
    index :url

    has_n(:links_to).to(PageNode)
  end

  module Store
    def self.put page
      Neo4j::Transaction.run do 
        node = PageNode.create_from page
        page.links.each do |linked_page|
          linked_node = PageNode.create_from linked_page
          node.links_to.new linked_node
        end
      end
    end

    def self.retrieve url
      Neo4j::Transaction.run do
        node = PageNode.find(:url => url).first
        page = Page.new(node.url, node.broken)
        node.links_to.each do |linked_node|
          page.links << Page.new(linked_node.url, linked_node.broken)
        end
        page
      end
    end
  end
end