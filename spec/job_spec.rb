require File.dirname(__FILE__)+'/spec_helper'

describe Spidie::Job do
  it 'should fetch a page, store it and enqueue the links' do
    url, url1, url2= "url",  "http://link1",  "http://link2"
    link1, link2 = stub('link1', :url => url1), stub('link2', :url => url2)
    page = stub('page', :links => [link1, link2], :url => url)
    
    Job.should_receive(:retrieve_or_create_page).with(url).and_return page
    Page.should_receive(:retrieve_links_for)

    Resque.should_receive(:enqueue).with(Job, url1)
    Resque.should_receive(:enqueue).with(Job, url2)
    
    Job.perform url
  end

  it "should avoid cycles or spider will get dizzy"
end