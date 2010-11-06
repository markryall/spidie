require File.dirname(__FILE__)+'/spec_helper.rb'

require 'fileutils'
require 'spidie/jobutils'
require 'json'

describe 'the spider, the spider' do
  before(:each) do
    Resque.redis.flushall 
    Resque.enqueue Spidie::JobUtils::CleanDBJob
    wait_for_jobs 1
    [REPORT_FILE].each {|f| FileUtils.rm f if File.exist? f }    
  end

  def wait_for_jobs num
    num_p = -1
    60.times do
      num_p = Resque.info[:processed]
      #puts "num processed is #{num_p}"
      if num_p == num
        Resque.redis.flushall
        break
      end
      sleep 2
    end
    raise "timed out waiting for jobs to finish" unless num_p == num
  end

  def retrieve_report_after_jobs num_jobs
    wait_for_jobs num_jobs
    Resque.enqueue Spidie::ReportJob
    wait_for_jobs 1
    JSON.parse open(REPORT_FILE).read
  end

  it 'should embark on a tasty mission with all sorts of links' do
    Resque.enqueue Spidie::Job, 'http://localhost:4567/page_with_two_working_links_and_two_broken.html'

    report = retrieve_report_after_jobs 8

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

    report = retrieve_report_after_jobs 1
    
    report["total_pages"].should == 1
    report["num_broken"].should == 1
    report["broken_pages"].should include url
  end
end