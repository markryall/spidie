require File.dirname(__FILE__)+'/spec_helper'

describe "spider database" do
  include Store

  before(:each) do
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
  
  it 'should list good_pages which we have visited that are not broken' do
    while_shopping do
      Page.new :url => "good_page", :broken => false, :visited => true
      Page.new :url => "unvisited_page", :broken => false, :visited => false
      Page.new :url => "broken_page", :broken => true, :visited => true
    end
    
    while_shopping do
      good_pages.map {|page| page.url}.should == ["good_page"]
    end
  end
  
  it 'should list broken_pages which we have visited' do
    while_shopping do
      Page.new :url => "broken_page", :broken => true, :visited => true
      Page.new :url => "unvisited_page", :broken => false, :visited => false
      Page.new :url => "good_page", :broken => false, :visited => true
    end
    
    while_shopping do
      broken_pages.map {|page| page.url}.should == ["broken_page"]
    end
  end
  
  it 'should return sensible stuff when no pages' do
    while_shopping do
      broken_pages.count.should == 0
      good_pages.count.should == 0

      broken_pages.map{|page| page.url}.should == []
      good_pages.map{|page| page.url}.should == []
    end
  end
end





