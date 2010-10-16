require 'neo4j'

module Spidie
  module Store
    def while_shopping
      Neo4j::Transaction.run { yield }
    end

    def create_page url, broken=false
      Page.new :url => url, :broken => broken
    end

    def retrieve_page url
      Page.find(:url => url).first
    end

    def retrieve_or_create_page url
      retrieve_page(url) || create_page(url)
    end

    def pages
      pages = []
      Neo4j.all_nodes do |node|
        pages << node if node.instance_of?(Spidie::Page)
      end
      pages
    end

    def broken_pages
      Page.find('broken: true')
    end
  end
end