require 'spidie/logger'
require 'spidie/store'
require 'spidie/report'

module Spidie
  module ReportJob
    extend Store
    extend Logger

    @queue = :urls

    def self.perform
      log "Spidie:ReportJob.perform (creating report)"

      report = Report.new

      while_shopping do
        report.good_pages = good_pages.map {|page| page.url}
        report.broken_pages = broken_pages.map {|page| page.url}
        report.total_pages = report.good_pages.count + report.broken_pages.count
        report.num_broken = report.broken_pages.count
      end

      open('tmp/report.json', 'w') {|f| f.puts report.to_json }
    end
  end
end
