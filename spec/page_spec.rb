require File.dirname(__FILE__)+'/spec_helper'

describe "page" do
  it "should store itself" do
    page = Page.new("bla")
    Store.should_receive(:put).with(page)
    page.store
  end
  
  it "should be initialised sensibly" do
    p = Page.new("foo")
    p.links.should == []
    p.broken?.should be_false
  end
end

describe "page retrieve" do
  before(:each) do
    @url = "url"
    @httpclient = mock("client")
    HTTPClient.should_receive(:new).and_return @httpclient
  end
  
  it "should retrieve a health page" do
    pending
    links = ["http://link1", "http://link2", "http://link3"]

    result = OpenStruct.new(:content => "some html", :status => 200)
    @httpclient.should_receive(:get).with(@url).and_return result
    
    HtmlParser.should_receive(:extract_links).with(result.content).and_return links
    
    page = Page.retrieve(@url)
       
    page.url.should == @url
    page.links.should == links
    page.broken?.should be_false
  end
  
  it "should retrieve a broken page" do
    result = OpenStruct.new(:status => 404)

    @httpclient.should_receive(:get).with(@url).and_return result
    HtmlParser.should_not_receive(:extract_links)
    
    page = Page.retrieve(@url)
       
    page.url.should == @url
    page.links.should == []
    page.broken?.should be_true
  end
  
end
  
  
  
