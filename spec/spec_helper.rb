$: << File.dirname(__FILE__)+'/../lib'

require 'spidie/page'
require 'spidie/store'
require 'spidie/job'
require 'spidie/report_job'
require 'neo4j'

include Spidie

REPORT_FILE = 'tmp/report.json'
LOG_FILE = 'tmp/spidie.log'

def clean_db
  Neo4j::Transaction.run do
    Neo4j.all_nodes do |node|
      node.del unless node.neo_id == 0
    end
  end
end

def finish_tx
  return unless @tx
  @tx.success
  @tx.finish
  @tx = nil
end

def rollback_tx
  return unless @tx
  @tx.failure
  @tx.finish
  @tx = nil
end

def new_tx
  finish_tx if @tx
  @tx = Neo4j::Transaction.new
end