require File.dirname(__FILE__)+'/spec_helper'

describe "spider database" do
  include Store

  before do
    clean_db
    @url = 'http://www.google.com'
    @linked_url = 'http://images.google.com'
  end

  it 'should store a page by url' do
    while_shopping do
      create_page @url
    end

    while_shopping do
      found_page = retrieve_page @url
      found_page.url.should == @url
      found_page.broken.should == false
    end
  end

  it 'should store links with url' do
    while_shopping do
      page = create_page @url
      page.links << create_page(@linked_url)
    end

    while_shopping do
      found_page = retrieve_page @url
      found_page.links.map{|page| page.url}.should == [@linked_url]
    end
  end
end