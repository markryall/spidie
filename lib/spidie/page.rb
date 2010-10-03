module Spidie
  class Page < Struct.new(:url, :links)
    def store
      
    end
    
    def self.retrieve
      Page.new
    end
  end
end