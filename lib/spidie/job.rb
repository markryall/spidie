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
      begin
        log "Spidie:Job.perform(#{url}) started"
        while_shopping do
          page = retrieve_or_create_page url
          if page.visited
            log "SKIPPING already visited page"
          else
            page.get_content_and_populate_links
            page.links.each do |linked_page|
              log "ENQUEUING #{linked_page.url}"
              Resque.enqueue Spidie::Job, linked_page.url unless linked_page.visited
            end
          end
        end
      ensure
        log "Spidie:Job.perform(#{url}) completed"
      end
    end
  end
end
