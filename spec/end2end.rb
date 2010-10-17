require File.dirname(__FILE__)+'/spec_helper.rb'

require 'fileutils'
require 'spidie/jobutils'
require 'json'

SUCCESS_FILE = 'tmp/success'
REPORT_FILE = 'report'

describe 'the spider, the spider' do
  before(:each) do
    Resque.enqueue Spidie::JobUtils::CleanDBJob
    [SUCCESS_FILE, REPORT_FILE].each {|f| FileUtils.rm f, :force => true }
  end
  
  def wait_for_file file
    10.times do
      break if File.exists?(file)
      sleep 1
    end
    raise "timed out waiting for #{file} file" unless File.exists?(file)
  end
  
  def verify_url url
    Resque.enqueue Spidie::TestJob, url
    wait_for_file SUCCESS_FILE
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
    url = 'http://localhost:4567/hi.html'
    Resque.enqueue Spidie::Job, url

    Resque.enqueue Spidie::ReportJob
    wait_for_file REPORT_FILE
        
    report = JSON.parse open(REPORT_FILE).read
    report["total_pages"].should == 1
    report["num_broken"].should == 1
    report["broken_pages"].should include url
  end
end
