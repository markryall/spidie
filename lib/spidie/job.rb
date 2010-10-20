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
      log "Spidie:Job.perform(#{url})"
      while_shopping do
        page = retrieve_or_create_page url
        if page.visited
          log "skipping already visited page"
        else
          Page.retrieve_links_for(page)
          page.links.each do |linked_page|
            log "enqueing #{linked_page.url}"
            Resque.enqueue Spidie::Job, linked_page.url
          end
        end
      end
    end
  end

  module TestJob
    extend Logger

    @queue = :urls

    def self.perform url
      log "Spidie:TestJob.perform(#{url})"

      node = nil
      Neo4j::Transaction.run do
        if Page.find(:url => url).first
          log '  found it'
          FileUtils.touch "tmp/success"
        else
          log '  found it - THE OPPOSITE!'
        end
      end
    end
  end
end
