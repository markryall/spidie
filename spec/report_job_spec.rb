require File.dirname(__FILE__)+'/spec_helper'

require 'json'
require 'spidie/report'
require 'spidie/report_job'

describe "report job" do
  include Store

  before do
    FileUtils.rm "report", :force => true
  end

  it "should report stuff" do
    Page = Struct.new(:url, :broken)
    ReportJob.should_receive(:good_pages).and_return [Page.new("good_page",false)]
    ReportJob.should_receive(:broken_pages).and_return [Page.new("broken_page1",true), Page.new("broken_page2", true)]
     
    ReportJob.perform
      
    report_json = JSON.parse open("report").read
    report_json["total_pages"].should == 3
    report_json["num_broken"].should == 2
    report_json["broken_pages"].should == ["broken_page1", "broken_page2"]
    report_json["good_pages"].should == ["good_page"]
  
  end
end