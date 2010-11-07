require File.dirname(__FILE__)+'/spec_helper'

require 'spidie/html_parser'

describe Spidie::HtmlParser do
  it 'should find no links in nil document' do
    parse('' ,nil).should == []
  end

  it 'should find no links in empty document' do
    parse('' ,nil).should == []
  end

  it 'should find links in document with absolute urls' do
    parse('http://bar' ,'<a href="http://foo/index.html"></a><a href="http://bar/index.html"></a>').should == ["http://foo/index.html","http://bar/index.html" ]
  end

  it 'should convert simple relative links to absolute' do
    parse('http://www.google.com' ,'<a href="index.html"></a>').should  == ['http://www.google.com/index.html']
  end
  
  it 'should convert simple relative links to absolute' do
    parse('http://www.google.com/' ,'<a href="/index.html"></a>').should  == ['http://www.google.com/index.html']
  end

  it 'should convert simple relative links to absolute' do
    parse('http://www.google.com/a/b/c.cgi?a=b' ,'<a href="/c/d/index.html"></a>').should == ['http://www.google.com/c/d/index.html']
  end
  
  it 'should not convert mangled links - they will be treated as broken links' do
    parse("http://www.qld.gov.au/" ,'<a href="/some garbage"></a>').should  == ["/some garbage"]
  end

  it 'should trim spaces' do
    parse( "http://www.qld.gov.au" ,'<a href=" /thing.html "></a>').should  == ["http://www.qld.gov.au/thing.html"]
    parse("http://www.qld.gov.au" ,'<a href=" http://bla/thing.html "></a>').should  == ["http://bla/thing.html"]
  end
  
  it 'should ignore relative anchors' do
    parse("http://foo", '<a href="#bar"></a>').should == []
  end
  
  it 'should strip anchors from absolute and relative links' do
    parse( "http://www.qld.gov.au" ,'<a href="/thing.html#bla"></a>').should  == ["http://www.qld.gov.au/thing.html"]
    parse("http://www.qld.gov.au" ,'<a href="http://bla/thing.html#dfdfd"></a>').should  == ["http://bla/thing.html"]
  end
  
  def parse page_url, html
    Spidie::HtmlParser.new(page_url).extract_links html
  end
    
end
