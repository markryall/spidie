require 'spidie/logger'
require 'spidie/store'

module Spidie
  module ReportJob
    extend Store
    extend Logger

    def self.perform
      log { "Spidie:ReportJob.perform (creating report)" }
      
      report = Report.new
      
      while_shopping do  
        report.total_pages = pages.count
        report.num_broken = broken_pages.count
      end
      
      open("report", 'w') {|f| f.puts report.to_json }
    end
  end
end