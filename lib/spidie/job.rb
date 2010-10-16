require 'resque'
require 'spidie/page'
require 'spidie/store'

module Spidie
  module Job
    extend Store

    @queue = :urls

    def self.perform url
      while_shopping do
        puts "grabbing #{url}"

        page = retrieve_page(url)
        Page.retrieve_links_for page

        page.links.each do |linked_page|
          puts "enqueing #{linked_page.url}"
          Resque.enqueue Spidie::Job, linked_page.url
        end
      end
    end
  end

  module TestJob
    @queue = :urls

    def self.perform url
      puts "asked to verify existance of #{url}"

      node = nil
      Neo4j::Transaction.run do
        if Page.find(:url => url).first
          puts 'found it'
          File.open("success", "w") {|f| f.puts "something" }
        else
          puts 'found it - THE OPPOSITE!'
        end
      end
    end
  end
end
