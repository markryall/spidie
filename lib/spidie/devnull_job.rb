require 'spidie/logger'

module Spidie
  module Job
    extend Logger

    @queue = :urls

    def self.perform url
      log { "Spidie:Job.perform(#{url}) (draining queue)" }
    end
  end
end