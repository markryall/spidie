module Spidie
  class Page < Struct.new(:url, :links)
    def store
      
    end
    
    def self.retrieve url
      Page.new
    end
  end
end