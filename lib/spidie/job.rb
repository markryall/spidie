require 'resque'
require 'spidie/page'
require 'spidie/store'
require 'fileutils'

module Spidie
  module Job
    extend Store

    @queue = :urls

    def self.perform url
      puts "Spidie:Job.perform(#{url})"
      while_shopping do
        if retrieve_page(url)
          puts "already visited #{url}"
        else
          page = create_page url

          Page.retrieve_links_for(page).each do |link|
            puts "enqueing #{link}"
            Resque.enqueue Spidie::Job, link
          end
        end
      end
    end
  end

  module TestJob
    @queue = :urls

    def self.perform url
      puts "Spidie:TestJob.perform(#{url})"

      node = nil
      Neo4j::Transaction.run do
        if Page.find(:url => url).first
          puts 'found it'
          FileUtils.touch "tmp/success"
        else
          puts 'found it - THE OPPOSITE!'
        end
      end
    end
  end
end
