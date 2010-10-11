$: << File.dirname(__FILE__)+'/../lib'

require 'spidie/page'
require 'spidie/store'
require 'spidie/job'
require 'neo4j'

include Spidie

def clean_db
  Neo4j::Transaction.run { Neo4j.all_nodes {|node| node.del }}
end