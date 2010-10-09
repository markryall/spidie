Gem::Specification.load('gemspec').dependencies.each { |dep| gem dep.name, dep.requirement }

require 'gemesis/rake'
require 'resque/tasks'

task "resque:setup" => :environment

task :environment do
  $: << File.dirname(__FILE__)+'/lib'
  require 'spidie/job'
end

namespace :redis do
  desc 'start redis'
  task :start do
    puts "'daemonise yes' in /usr/local/etc/redis.conf or this task will block"
    system "redis-server /usr/local/etc/redis.conf"
  end

  desc 'stop redis'
  task :stop do
    system "kill #{File.read('/usr/local/var/run/redis.pid')}"
  end
end

task :agent do
end

task :spec => [:clean] do
  sh 'spec spec'
end

task :clean do
  rm_rf 'tmp/test-spider-database'
end