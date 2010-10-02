require 'resque'
require 'spidie/link_extractor'
require 'spidie/page_grabber'

module Spidie
  module Job
    @queue = :urls
    
    def self.perform url
      puts "grabbing #{url}"
      
      page = PageGrabber.grab(url)
      puts page.inspect      page.store()
      
      page.links.each do |link|
        Resque.enqueue Spidie::Job, link
      end
=begin
      LinkExtractor.new(url).each do |link|
        puts link
        #Resque.enqueue Spidie::Job, url
      end
=end

    end
  end
end
