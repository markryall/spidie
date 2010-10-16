require 'resque'
require 'spidie/page'
require 'spidie/store'
require 'fileutils'

module Spidie
  module Job
    @queue = :urls
    
    def self.perform url
      puts "grabbing #{url}"

      page = Page.retrieve(url)
      page.store

      page.links.each do |linked_page|
        puts "enqueing #{linked_page.url}"
        Resque.enqueue Spidie::Job, linked_page.url
      end
    end
  end

  module TestJob
    @queue = :urls

    def self.perform url
      puts "asked to verify existance of #{url}"

      node = nil
      Neo4j::Transaction.run do
        if PageNode.find(:url => url).first
          puts 'found it'
          FileUtils.touch "tmp/success"
        else
          puts 'found it - THE OPPOSITE!'
        end
      end
    end
  end
end
