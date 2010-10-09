require File.dirname(__FILE__)+'/spec_helper'

describe "page" do
  it "should store itself" do
    page = Page.new
    Store.should_receive(:put).with(page)
    page.store
  end
  
  it "should get a page from the interwebs" do
    pending
    links = ["http://link1", "http://link2", "http://link3"]
    url = "url"
    content = "some html"
    
    HttpGet.should_recieve(:get).with(url).and_return HttpResponse.new(200, content)
    HtmlParser.should_receive(:extract_links).with(content).and_return links
    
    page = Page.retrieve(url)
       
    page.url.should == url
    page.links.should == links
    page.broken?.should be_false
  end
  
end