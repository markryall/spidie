require File.dirname(__FILE__)+'/spec_helper'

describe "spider database" do
  before do
    clean_db
    @url = 'http://www.google.com'
    @linked_url = 'http://images.google.com'
  end

  it 'should store a page by url' do
    page = Page.new(@url)
    page.broken = true
    Store.put(page)

    found_page = Store.retrieve(@url)
    found_page.url.should == @url
    found_page.broken.should == page.broken
  end

  it 'should store links with url' do
    page = Page.new(@url)
    page.links << Page.new(@linked_url)
    Store.put(page)

    found_page = Store.retrieve(@url)
    found_page.links.map{|page| page.url}.should == [@linked_url]
  end
end