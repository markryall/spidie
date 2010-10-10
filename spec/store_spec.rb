require File.dirname(__FILE__)+'/spec_helper'


describe "spider database" do
  it 'should store a page by url' do
    url = 'http://www.google.com'

    page = Page.new(url)
    page.broken = true
    Store.put(page)

    found_page = Store.retrieve(url)
    found_page.url.should == url
    found_page.broken.should == page.broken
  end
end