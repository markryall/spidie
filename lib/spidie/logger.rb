module Spidie
  module Logger
    def log message=nil
      if ENV['LOG_PATH']
        File.open(ENV['LOG_PATH'], 'a') do |file|
          file.puts format_message(message) if message
          file.puts format_message(yield) if block_given?
        end
      end
    end

    def format_message message
      "#{Time.now}: #{message}"
    end
  end
end