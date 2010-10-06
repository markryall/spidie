require File.dirname(__FILE__)+'/spec_helper.rb'



describe 'the spider, the spider' do
  
  before(:each) do
    File.delete 'success' if File.exist?('success')
  end
  
  it 'should consume with eagerness the url for a page with no links' do
    url = 'http://localhost:4567/hi.html'

    Resque.enqueue Spidie::Job, url
    Resque.enqueue Spidie::TestJob, url
    
    20.times do
      break if File.exists?("success")
      sleep 0.2
    end
    
    raise 'timed out waiting for success' unless File.exists?("success") 
  end
end



# start redis
# start resque agent
# run enspidie with a url

# ... awesomeness


# 