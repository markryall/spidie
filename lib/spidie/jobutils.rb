require 'neo4j'

module Spidie
  module JobUtils
    module CleanDBJob
      extend Logger
      @queue = :urls
      def self.perform
        log {"CleanDBJob: cleaning db"}
        Neo4j::Transaction.run do
          Neo4j.all_nodes do |node|
            node.del unless node.neo_id == 0
          end
        end
      end
    end
  
    module DrainQueueJob
      extend Logger
      @queue = :urls
      def self.perform url
        log { "Spidie:Job.perform(#{url}) (draining queue)" }
      end
    end
  end
end