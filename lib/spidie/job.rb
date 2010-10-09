require 'resque'
require 'spidie/page'
require 'spidie/store'

module Spidie
  module Job
    @queue = :urls
    
    def self.perform url
      puts "grabbing #{url}"

      Store.put Page.new(url, [])

      #page = Page.retrieve(url)
      #page.store
      # 
      #page.links.each do |link|
      #   Resque.enqueue Spidie::Job, link
      # end
      #LinkExtractor.new(url).each do |link|
      #  puts link
        #Resque.enqueue Spidie::Job, url
      #end
    end
  end
  
  module TestJob
    @queue = :urls

    def self.perform url
      puts "asked to verify existance of #{url}"
      node = Neo4j::Node.find('url: '+ url).first

      if node[:url] == url 
        File.open("success", "w") {|f| f.puts "something" }
      end
    end
  end
end
