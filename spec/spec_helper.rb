$: << File.dirname(__FILE__)+'/../lib'

require 'spidie/page'
require 'spidie/store'
require 'spidie/job'
require 'neo4j'

include Spidie

def clean_db
  Neo4j::Transaction.run do
    Neo4j.all_nodes do |node|
      node.del unless node.neo_id == 0
    end
  end
end