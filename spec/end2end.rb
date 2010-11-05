require File.dirname(__FILE__)+'/spec_helper.rb'

require 'fileutils'
require 'spidie/jobutils'
require 'json'

describe 'the spider, the spider' do
  before(:each) do
    Resque.enqueue Spidie::JobUtils::CleanDBJob
    [REPORT_FILE].each {|f| FileUtils.rm f if File.exist? f }
  end

  def wait_for_report
    10.times do
      break if File.exists? REPORT_FILE 
      sleep 1
    end
    raise "timed out waiting for report file" unless File.exists? REPORT_FILE
  end

  def log_line_exists? string
    exists = false
    if File.exists? LOG_FILE
      File.open(LOG_FILE) do |file|
        file.each do |line|
          return true if line.include? string
        end
      end
    end
    exists
  end

  def wait_for_url url
    30.times do
      break if log_line_exists? "Spidie:Job.perform(#{url}) completed"
      sleep 1
    end
    raise "timed out waiting for #{url} to be processed" unless log_line_exists? "Spidie:Job.perform(#{url}) completed"
  end

  def retrieve_report
    Resque.enqueue Spidie::ReportJob
    wait_for_report
    JSON.parse open(REPORT_FILE).read
  end

  it 'should embark on a tasty mission with all sorts of links' do
    Resque.enqueue Spidie::Job, 'http://localhost:4567/page_with_two_working_links_and_two_broken.html'

    wait_for_url 'http://localhost:4567/broken_relative_link.html'

    report = retrieve_report

    working_urls = ["http://localhost:4567/page_with_two_working_links_and_two_broken.html",
     "http://localhost:4567/page_with_no_links.html",
     "http://localhost:4567/page_with_relative_links_one_fine_one_broken.html",
     "http://localhost:4567/working_relative_link_with_cyle.html"]
    broken_urls = ["http://localhost:4567/broken_link.html",
      "http://localhost:11111/bad_port.html",
      "http://foo.localhost:4567/bad_port.html",
      "http://localhost:4567/broken_relative_link.html"]

    report["total_pages"].should == 8
    report["num_broken"].should == 4
    working_urls.each {|url| report["good_pages"].should include url}
    broken_urls.each {|url| report["broken_pages"].should include url}
  end

  it 'should consume without disappointment a single broken link' do
    url = 'http://localhost:4567/doesnt_exist.html'
    Resque.enqueue Spidie::Job, url

    wait_for_url url

    report = retrieve_report
    
    report["total_pages"].should == 1
    report["num_broken"].should == 1
    report["broken_pages"].should include url
  end
end