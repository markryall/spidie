require File.dirname(__FILE__)+'/spec_helper'

describe "page" do
  it "should store itself" do
    page = Page.new("bla",[])
    Store.should_receive(:put).with(page)
    page.store
  end
  
  it "should have empty links array if links are nil" do
    p = Page.new("foo", nil)
    p.links.should == []
  end
  
  it "should get a page from the interwebs" do
    links = ["http://link1", "http://link2", "http://link3"]
    url = "url"
    
    result = OpenStruct.new(:content => "some html")
    
    httpclient = mock("client")
    HTTPClient.should_receive(:new).and_return httpclient
    httpclient.should_receive(:get).with(url).and_return result
    
    HtmlParser.should_receive(:extract_links).with(result.content).and_return links
    
    page = Page.retrieve(url)
       
    page.url.should == url
    page.links.should == links
    page.broken?.should be_false
  end
  
end