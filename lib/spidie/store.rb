require 'neo4jr-simple'

module Spidie
  module Store
    Neo4jr::Configuration.database_path = File.dirname(__FILE__)+'/../../tmp/test-spider-database'

    def self.put page
      Neo4jr::DB.execute do |neo|
        node = neo.createNode
        node[:identifier] = page.url
      end
    end

    def self.retrieve url
      node = Neo4jr::DB.execute do |neo|
        neo.find_node_by_identifier("page.url")
      end
      Page.new node[:identifier]
    end
  end
end