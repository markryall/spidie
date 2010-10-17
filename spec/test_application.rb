require 'rubygems'
require 'sinatra'
require 'markaby'

File.open('tmp/test_web.pid', 'w') {|f| f.puts Process.pid }

get '/page_with_two_working_links_and_one_broken.html' do
  Markaby::Builder.new.html do
    head { title 'index.html' }
    body do
      ul {
        li { a 'a link', :href => 'http://localhost:4567/page_with_relative_links_one_fine_one_broken.html' }
        li { a 'a link', :href => 'http://localhost:4567/page_with_no_links.html' }
        li { a 'a link', :href => 'http://localhost:4567/broken_link.html' }
      }
    end
  end
end

get '/page_with_no_links.html' do
  ''
end

get '/page_with_relative_links_one_fine_one_broken.html' do
  Markaby::Builder.new.html do
    head { title 'index.html' }
    body do
      ul {
        li { a 'a link', :href => '/working_relative_link.html' }
        li { a 'a link', :href => '/broken_relative_link.html' }
      }
    end
  end
end

get '/working_relative_link.html' do
  ''
end

