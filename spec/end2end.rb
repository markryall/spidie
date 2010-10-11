require File.dirname(__FILE__)+'/spec_helper.rb'

describe 'the spider, the spider' do
  def verify_url url
    File.delete 'success' if File.exist?('success')
    Resque.enqueue Spidie::TestJob, url

    10.times do
      break if File.exists?("success")
      sleep 1
    end

    raise 'timed out waiting for success' unless File.exists?("success")
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
    pending
    Resque.enqueue Spidie::Job, 'http://localhost:4567/2_index.html'
    verify_url 'http://localhost:4567/2_index.html'
    verify_url 'http://localhost:4567/2_link.html'
  end
end