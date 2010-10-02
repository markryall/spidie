require 'neo4jr-simple'

module Spidie
  module Store
    def self.put page
      Neo4jr::DB.execute do |neo|
        node = neo.createNode
        node[:identifier] = page.url
      end
    end

    def self.retrieve url
      page = Neo4jr::DB.execute do |neo|
        neo.find_node_by_identifier(url)
      end
      Page.new page[:identifier]
    end
  end
end