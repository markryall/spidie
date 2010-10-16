require File.dirname(__FILE__)+'/spec_helper.rb'

require 'fileutils'
require 'json'

describe 'the spider, the spider' do
  
  def wait_for_file file
    10.times do
      break if File.exists?(file)
      sleep 1
    end
    raise 'timed out waiting for #{file} file' unless File.exists?(file)
  end
  
  def verify_url url
    success_file = 'tmp/success'
    FileUtils.rm success_file, :force => true
    Resque.enqueue Spidie::TestJob, url
    wait_for_file success_file
  end
  
  it 'should consume with eagerness the url for a page with no links' do
    Resque.enqueue Spidie::Job, 'http://localhost:4567/0_index.html'
    verify_url 'http://localhost:4567/0_index.html'
  end

  it 'should consume with gusto the url for a page with a single absolute link' do
    Resque.enqueue Spidie::Job, 'http://localhost:4567/1_index.html'
    verify_url 'http://localhost:4567/1_index.html'
    verify_url 'http://localhost:4567/1_link.html'
  end

  it 'should consume with relish the url for a page with a single relative link' do
    Resque.enqueue Spidie::Job, 'http://localhost:4567/2_index.html'
    verify_url 'http://localhost:4567/2_index.html'
    verify_url 'http://localhost:4567/2_link.html'
  end
  
  it 'should consume with eagerness the url for a page with no links and give a report' do
    pending
    report_file = "tmp/report"
    Resque.enqueue Spidie::Job, 'http://localhost:4567/hi.html'
    Resque.enqueue Spidie::ReportJob
    
    10.times do
      break if File.exists?(report_file)
      sleep 1
    end
    raise 'timed out waiting for report' unless File.exists?(report_file) 
    
    report = JSON.parse open(report_file).read
    report.total_pages.should == 1
    report.num_broken.should == 1
    
  end
end
