require 'neo4j'

module Spidie
  class PageNode
    include Neo4j::NodeMixin
    property :url
    index :url
  end

  module Store
    def self.put page
      Neo4j::Transaction.run do |neo|
        node = PageNode.new
        node.url = page.url
      end
    end

    def self.retrieve url
      Neo4j::Transaction.run do
        node = PageNode.find(:url => url).first
        Page.new node.url
      end
    end
  end
end