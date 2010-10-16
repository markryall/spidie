require File.dirname(__FILE__)+'/spec_helper'

describe Spidie::Job do
  before do
    @url = stub('url')
    @page = stub('page', :url => @url)
    Job.stub!(:retrieve_or_create_page).with(@url).and_return @page
  end

  it 'should only continue when the page does not already exist' do
    @page.should_receive(:visited).and_return true
    Page.should_not_receive :retrieve_links_for
    Job.perform @url
  end

  it 'should fetch a page, store it and enqueue the links' do
    url1, url2 = stub('url1'), stub('url2')
    page1, page2 = stub('page1', :url => url1), stub('page2', :url => url2)
    @page.should_receive(:visited).and_return false
    Page.should_receive(:retrieve_links_for).with(@page)
    @page.should_receive(:links).and_return [page1, page2]

    Resque.should_receive(:enqueue).with(Job, url1)
    Resque.should_receive(:enqueue).with(Job, url2)

    Job.perform @url
  end
end