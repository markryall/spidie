require File.dirname(__FILE__)+'/spec_helper'

require 'json'
require 'spidie/report'

describe "report job" do
  include Store

  before do
    clean_db
  end

  it "should report stuff" do
    while_shopping do
      Page.new :url => "good_page", :broken => false
      Page.new :url => "broken_page", :broken => true
    end
    
    report_file = "report"

    while_shopping do
      report = Report.new
      report.total_pages = pages.count
      report.num_broken = broken_pages.count
      
      open(report_file, 'w') {|f| f.puts report.to_json }
    end
      
    report_json = JSON.parse open(report_file).read
    report_json["total_pages"].should == 2
    report_json["num_broken"].should == 1
  end
end