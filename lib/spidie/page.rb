require 'spidie/store'

module Spidie
  class Page < Struct.new(:url, :links)
    
    def store
      Store.put self
    end
        
    def self.retrieve url
      Page.new
    end
  end
end