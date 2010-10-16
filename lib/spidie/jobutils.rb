require 'neo4j'

module Spidie::JobUtils
  module CleanDBJob
    @queue = :urls
    def self.perform
      Neo4j::Transaction.run do
        Neo4j.all_nodes do |node|
          node.del unless node.neo_id == 0
        end
      end
    end
  end
end