require 'neo4j'
require 'spidie/page'
require 'spidie/store'

module Spidie
  class Dumper
    def dump
      Neo4j::Transaction.run do
        Neo4j.info
        puts
        Neo4j.all_nodes do |node|
          display_node node
          node.rels.each do |rel|
            puts "  #{rel.relationship_type}"
            display_node rel.end_node, 1
          end
        end
      end
    end
  private
    def display_node node, indent=0
      puts "#{'  '*indent}Node id #{node.neo_id}"
      node.props.keys.each do |key|
        puts "#{'  '*indent}  #{key}=#{node.props[key]}"
      end
    end
  end
end