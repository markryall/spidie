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
      Page.find(:url => url).first || create_page(url)
    end
  end
end