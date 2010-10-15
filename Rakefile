Gem::Specification.load('gemspec').dependencies.each { |dep| gem dep.name, dep.requirement }

$: << File.dirname(__FILE__)+'/rake'

require 'gemesis/rake'
require 'resque/tasks'
require 'pids'

task "resque:setup" => :environment

task :environment do
  $: << File.dirname(__FILE__)+'/lib'
  require 'spidie/job'
  Pids.persist 'tmp/spidie.pid'
end

task :default do
  sh "rake spec"
  sh "rake acceptance_tests"
end

task :spec => [:clean] do
  sh 'spec spec'
end

desc 'clean'
task :clean => ['redis:stop', 'spidie:stop', 'test_web:stop'] do
  rm_rf 'tmp'
  mkdir_p 'tmp'
end

desc 'how to start resque-web'
task :resque_web do
  puts "you can't use resque-web with jruby"
  puts "rvm use default; gem install resque; resque-web "
end

desc 'open resque-web page - u must first start it with ruby'
task :resque_view do
  sh "open 'http://0.0.0.0:5678/overview'"
end

desc 'run acceptance tests, starts up spider and fake webserver first'
task :acceptance_tests => [:clean, 'redis:start', 'test_web:start', 'spidie:start'] do
  sh "spec spec/end2end.rb"
end

namespace :redis do
  Pids.create_tasks :name => 'redis',
    :command => 'redis-server /usr/local/etc/redis.conf',
    :pid => '/usr/local/var/run/redis.pid'
end

namespace :spidie do
  Pids.create_tasks :name => 'spidie',
    :command => 'QUEUE=urls rake resque:work > tmp/spidie.log 2>&1 &',
    :pid => 'tmp/spidie.pid'
end

namespace :test_web do
  Pids.create_tasks :name => 'test_web',
    :command => 'ruby spec/test_application.rb > tmp/test_web.log 2>&1 &',
    :pid => 'tmp/test_web.pid'
end