require 'neo4j'
require 'spidie/logger'

Lucene::Config[:store_on_file] = true
Lucene::Config[:storage_path] = "tmp/lucene"

module Spidie
  module Store
    include Logger

    def while_shopping
      Neo4j::Transaction.run { yield }
    end

    def create_page url
      log { "creating new page with url #{url}" }
      Page.new :url => url, :broken => false, :visited => false
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
      Page.find(:broken => true)
    end
    
    def good_pages
      Page.find(:broken => false)
    end
    
  end
end