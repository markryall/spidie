require 'rubygems'
require 'sinatra'
require 'markaby'

get '/0_index.html' do
  ''
end

get '/1_index.html' do
  Markaby::Builder.new.html do
    head { title 'index.html' }
    body do
      ul {
        li { a 'a link', :href => 'http://localhost:4567/1_link.html' }
      }
    end
  end
end

get '/1_link.html' do
  ''
end

get '/2_index.html' do
  Markaby::Builder.new.html do
    head { title 'index.html' }
    body do
      ul {
        li { a 'a link', :href => '/2_link.html' }
      }
    end
  end
end

get '/2_link.html' do
  ''
end