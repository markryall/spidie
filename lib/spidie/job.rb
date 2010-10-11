require 'resque'
require 'spidie/page'
require 'spidie/store'

module Spidie
  module Job
    @queue = :urls
    
    def self.perform url
      puts "grabbing #{url}"

      page = Page.retrieve(url)
      page.store
      
      page.links.each do |link|
        Resque.enqueue Spidie::Job, link
      end
    end
  end
  
  module TestJob
    @queue = :urls

    def self.perform url
      puts "asked to verify existance of #{url}"
      
      node = nil
      Neo4j::Transaction.run do
        node = PageNode.find(:url => url).first
      end

      if node and node.url == url 
        File.open("success", "w") {|f| f.puts "something" }
      end
    end
  end
end
