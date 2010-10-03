require 'resque'
require 'spidie/link_extractor'
require 'spidie/page'

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
end
