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
  
  it 'should list good_pages' do
    while_shopping do
      Page.new :url => "good_page1", :broken => false
      Page.new :url => "good_page2", :broken => false
      Page.new :url => "broken_page", :broken => true
    end
    result = good_pages
    result.count.should == 2
    urls = result.map {|page| page.url}
    urls.should include "good_page1"
    urls.should include "good_page2"
  end
  
  it 'should list broken_pages' do
    while_shopping do
      Page.new :url => "broken_page1", :broken => true
      Page.new :url => "broken_page2", :broken => true
      Page.new :url => "good_page", :broken => false
    end
    result = broken_pages
    result.count.should == 2
    urls = result.map {|page| page.url}
    urls.should include "broken_page1"
    urls.should include "broken_page2"
  end
  
  it 'should return sensible stuff when no pages' do
    broken_pages.count.should == 0
    good_pages.count.should == 0
    
    broken_pages.map{|page| page.url}.should == []
    good_pages.map{|page| page.url}.should == []
  end
end





