require 'resque/tasks'

task "resque:setup" => :environment

task :environment do
  $: << File.dirname(__FILE__)+'/lib'
  require 'spidie/job'
end

task :redis do
  sh "redis-server /usr/local/etc/redis.conf &"
end