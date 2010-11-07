
module Spidie
  class Config
    class << self
      def defaults
        @defaults ||= {
          :search_domain => "qld.gov.au"
        }
      end
      
      def []=(key, val)
        (@configuration ||= setup)[key] = val
      end
      
      def [](key)
        (@configuration ||= setup)[key]
      end
      
      def setup()
        @configuration = {}
        @configuration.merge!(defaults)
        @configuration
      end
    end
  end
end