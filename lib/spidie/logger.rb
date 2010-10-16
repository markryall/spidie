module Spidie
  module Logger
    def log
      if ENV['LOG_PATH']
        File.open(ENV['LOG_PATH'], 'a') do |file|
          file.puts "#{Time.now}: #{yield}"
        end
      end
    end
  end
end