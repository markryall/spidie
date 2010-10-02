require 'resque'
require 'spidie/link_extractor'

module Spidie
  module Job
    @queue = :urls
    
    def self.perform url
      puts "doing job hardcore with url #{url}"
      LinkExtractor.new(url).each do |link|
        puts link
        #Resque.enqueue Spidie::Job, url
      end
    end
  end
end
