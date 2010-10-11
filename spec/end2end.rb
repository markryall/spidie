require File.dirname(__FILE__)+'/spec_helper.rb'

require 'fileutils'
require 'json'

describe 'the spider, the spider' do
  
  before(:each) do
    FileUtils.rm 'success', :force => true
  end
  
  it 'should consume with eagerness the url for a page with no links' do
    
    Resque.enqueue Spidie::Job, 'http://localhost:4567/hi.html'
    Resque.enqueue Spidie::TestJob, 'http://localhost:4567/hi.html' 
    
    20.times do
      break if File.exists?("success")
      sleep 1
    end
    raise 'timed out waiting for success' unless File.exists?("success") 
    
  end
  
  it 'should consume with eagerness the url for a page with no links and give a report' do
    pending
    Resque.enqueue Spidie::Job, 'http://localhost:4567/hi.html'
    Resque.enqueue Spidie::ReportJob
    
    20.times do
      break if File.exists?("report")
      sleep 1
    end
    raise 'timed out waiting for report' unless File.exists?("report") 
    
    report = JSON.parse open("report").read
    report.total_pages.should == 1
    report.num_broken.should == 1
    
  end
  
  
end


