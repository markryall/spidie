require 'resque'
require 'spidie/page'
require 'spidie/store'
require 'spidie/logger'
require 'fileutils'

module Spidie
  module Job
    extend Logger
    extend Store

    @queue = :urls

    def self.perform url
      log { "Spidie:Job.perform(#{url})" }
      while_shopping do
        if retrieve_page(url)
          log { "  already visited #{url}" }
        else
          page = create_page url

          Page.retrieve_links_for(page).each do |link|
            log { "  enqueing #{link}" }
            Resque.enqueue Spidie::Job, link
          end
        end
      end
    end
  end

  module TestJob
    extend Logger

    @queue = :urls

    def self.perform url
      puts "Spidie:TestJob.perform(#{url})"

      node = nil
      Neo4j::Transaction.run do
        if Page.find(:url => url).first
          log { '  found it' }
          FileUtils.touch "tmp/success"
        else
          log { '  found it - THE OPPOSITE!' }
        end
      end
    end
  end
end
