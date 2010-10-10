require 'neo4j'

module Spidie
  class PageNode
    include Neo4j::NodeMixin
    property :url
    property :broken
    index :url
  end

  module Store
    def self.put page
      Neo4j::Transaction.run do 
        node = PageNode.new :url => page.url, :broken => page.broken
      end
    end

    def self.retrieve url
      Neo4j::Transaction.run do
        node = PageNode.find(:url => url).first
        page = Page.new(node.url)
        page.broken = node.broken
        page
      end
    end
  end
end