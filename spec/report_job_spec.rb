require File.dirname(__FILE__)+'/spec_helper'

require 'json'
require 'spidie/report'
require 'spidie/report_job'

describe "report job" do
  include Store

  before do
    clean_db
    FileUtils.rm "report", :force => true
  end

  it "should report stuff" do
    while_shopping do
      Page.new :url => "good_page", :broken => false
      Page.new :url => "broken_page", :broken => true
    end
    
    ReportJob.should_receive(:pages).and_return double('pages', :count => 2)
    ReportJob.should_receive(:broken_pages).and_return double('broken_pages', :count => 1)
     
    ReportJob.perform
      
    report_json = JSON.parse open("report").read
    report_json["total_pages"].should == 2
    report_json["num_broken"].should == 1
  end
end