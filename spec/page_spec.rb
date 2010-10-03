require File.dirname(__FILE__)+'/spec_helper'

describe "page" do
  it "should store itself" do
    page = Page.new
    Store.should_receive(:put).with(page)
    page.store
  end
  
  it "should get a page from the interwebs" do
=begin
    page = Page.retrieve("url")
       
       page.url.should == "url"
       page.links.should == ["http://link1", "http://link2"]
=end
   
  end
end