Gem::Specification.load('gemspec').dependencies.each { |dep| gem dep.name, dep.requirement }

require 'gemesis/rake'
require 'resque/tasks'

task "resque:setup" => :environment

module Pids
  def self.exist? name
    File.exist? path(name)
  end

  def self.persist name, pid=Process.pid
    File.open(path(name), 'w') {|f| f.puts pid}
  end

  def self.kill name
    system "kill #{File.read(path(name))}"
    FileUtils.rm path(name)
  end

  def self.path name
    FileUtils.mkdir_p 'tmp'
    "tmp/#{name}.pid"
  end
end

task :environment do
  $: << File.dirname(__FILE__)+'/lib'
  require 'spidie/job'
  Pids.persist 'spidie'
end

task :default => [:spec, :acceptance_tests]

namespace :redis do
  desc 'start redis'
  task :start do
    if File.exist? '/usr/local/var/run/redis.pid'
      puts 'redis already seems to be running'
    else
      puts "'daemonise yes' in /usr/local/etc/redis.conf or this task will block"
      system "redis-server /usr/local/etc/redis.conf"
    end
  end

  desc 'stop redis'
  task :stop do
    system "kill #{File.read('/usr/local/var/run/redis.pid')}"
    FileUtils.rm '/usr/local/var/run/redis.pid' if File.exist? '/usr/local/var/run/redis.pid'
  end
end

task :spec => [:squash_spider, :clean] do
  sh 'spec spec'
end

desc 'clean'
task :clean do
  rm_rf 'tmp'
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

namespace :spidie do
  task :start do
    if Pids.exist? 'spidie'
      puts 'the spider is already crawling'
    else
      puts 'the spider will be unleashed'
      sh "QUEUE=urls rake resque:work > tmp/worker.log 2>&1 &"
    end
  end

  task :stop do
    if Pids.exist? 'spidie'
      Pids.kill 'spidie'
    else
      puts 'the spider has not been unleashed'
    end
  end
end

desc 'tail spider logs'
task :tail_spider do
  sh "tail -f worker.log"
end

desc 'start spider'
task :start_spider => ['redis:start', 'spidie:start']

desc 'kill spider'
task :squash_spider => ['spidie:stop']

desc 'start fake webserver for returning web pages'
task :start_webserver do
  sh "ruby spec/test_application.rb > fake_webserver.log 2>&1 &"
end

desc 'run acceptance tests, starts up spider and fake webserver first'
task :acceptance_tests => [:squash_spider, :start_webserver, :start_spider,] do
  Rake::Task[:clean].execute
  sleep 10
  sh "spec spec/end2end.rb"
end

desc 'run acceptance tests assuming spider and fake webserver already running'
task :acceptance_tests_nostart do
  sh "spec spec/end2end.rb"
end