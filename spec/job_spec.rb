require File.dirname(__FILE__)+'/spec_helper'
describe "job" do
  it "should fetch a page, store it and enqueue the links" do
    pending
    url, link1, link2= "url",  "http://link1",  "http://link2"
    
    page = stub('page', :links => [link1, link2])
    Page.should_receive(:retrieve).with(url).and_return page
    page.should_receive(:store)
    
    Resque.should_receive(:enqueue).with(Job, link1)
    Resque.should_receive(:enqueue).with(Job, link2)
    
    Job.perform url
  end

  it "should avoid cycles or spider will get dizzy" do
    
  end
end