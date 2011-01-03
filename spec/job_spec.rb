require File.dirname(__FILE__)+'/spec_helper'


describe Spidie::Job do
  before do
    @url = stub('url')
    @page = stub('page', :url => @url)
    Job.stub!(:retrieve_or_create_page).with(@url).and_return @page
  end

  it 'should not request page when the page has not yet been visited' do
    @page.should_receive(:visited).and_return true
    @page.should_not_receive :get_content_and_populate_links
    Job.perform @url
  end

  it 'should request a page and enqueue only the links which we have not yet visited' do
    @page.stub(:visited).and_return false
    @page.should_receive(:get_content_and_populate_links)

    visited_url = stub('visited_url') 
    unvisited_url = stub('unvisited_url')
    visited_page = stub('visited_page', :url => visited_url, :visited => true) 
    unvisited_page = stub('unvisited_page', :url => unvisited_url, :visited => false)
    @page.stub(:links).and_return [visited_page, unvisited_page]

    Resque.should_not_receive(:enqueue).with(Job, visited_url)
    Resque.should_receive(:enqueue).with(Job, unvisited_url)

    Job.perform @url
  end

end
