require File.dirname(__FILE__)+'/spec_helper'

describe Spidie::Job do
  before do
    @url = stub('url')
  end

  it 'should only continue when the page does not already exist' do
    page = stub('page')
    Job.should_receive(:retrieve_page).with(@url).and_return page
    Page.should_not_receive :retrieve_links_for
    Job.perform @url
  end

  it 'should fetch a page, store it and enqueue the links' do
    url1, url2 = stub('url1'), stub('url2')
    page = stub('page', :url => @url)
    Job.should_receive(:retrieve_page).with(@url).and_return nil
    Job.should_receive(:create_page).with(@url).and_return page
    Page.should_receive(:retrieve_links_for).and_return([url1, url2])

    Resque.should_receive(:enqueue).with(Job, url1)
    Resque.should_receive(:enqueue).with(Job, url2)

    Job.perform @url
  end
end