require File.dirname(__FILE__)+'/spec_helper'

require 'json'
require 'spidie/report'
require 'spidie/report_job'

describe "report job" do
  include Store

  before do
    FileUtils.rm REPORT_FILE if File.exists? REPORT_FILE
  end

  it "should report stuff" do    
    ReportJob.should_receive(:good_pages).and_return [double('page', :url => 'good_page', :broken => false)]
    ReportJob.should_receive(:broken_pages).and_return [double('page', :url => 'broken_page1', :broken => true), double('page', :url => 'broken_page2', :broken => true)]
     
    ReportJob.perform
      
    report_json = JSON.parse open(REPORT_FILE).read
    report_json["total_pages"].should == 3
    report_json["num_broken"].should == 2
    report_json["broken_pages"].should == ["broken_page1", "broken_page2"]
    report_json["good_pages"].should == ["good_page"]
  end
end