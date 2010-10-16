require File.dirname(__FILE__)+'/spec_helper'

require 'spidie/jobutils'

describe "CleanDBJob" do
  include Store
  it "should clean db" do
    while_shopping do
      Page.new :url => "good_page", :broken => false
      Page.new :url => "broken_page", :broken => true
      pages.count.should be >= 2
    end
    
    JobUtils::CleanDBJob.perform
    
    while_shopping do
      pages.count.should == 0
    end
  end
end