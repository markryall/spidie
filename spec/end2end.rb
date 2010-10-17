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
  
  it 'should embark on a tasty mission with all sorts of links' do
    Resque.enqueue Spidie::Job, 'http://localhost:4567/page_with_two_working_links_and_one_broken.html'

    Resque.enqueue Spidie::ReportJob
    wait_for_file REPORT_FILE
    
    working_urls = ["http://localhost:4567/page_with_two_working_links_and_one_broken.html",
     "http://localhost:4567/page_with_no_links.html",
     "http://localhost:4567/page_with_relative_links_one_fine_one_broken.html",
     "http://localhost:4567/working_relative_link.html"]
    broken_urls = ["http://localhost:4567/broken_link.html","http://localhost:4567/broken_relative_link.html"]
    
    report = JSON.parse open(REPORT_FILE).read
    report["total_pages"].should == 6
    report["num_broken"].should == 2
    working_urls.each {|url| report["good_pages"].should include url}
    broken_urls.each {|url| report["broken_pages"].should include url}
  end

  
  it 'should consume without disappointment a single broken link' do
    url = 'http://localhost:4567/doesnt_exist.html'
    Resque.enqueue Spidie::Job, url

    Resque.enqueue Spidie::ReportJob
    wait_for_file REPORT_FILE
        
    report = JSON.parse open(REPORT_FILE).read
    report["total_pages"].should == 1
    report["num_broken"].should == 1
    report["broken_pages"].should include url
  end
end
