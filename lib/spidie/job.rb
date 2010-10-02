module Spidie
  module Job
    @queue = :urls
    
    def self.perform url
      puts "doing job with url #{url}"
    end
  end
end