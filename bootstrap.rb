# Load all libraries
require 'dotenv'
require 'json'
require 'uri'
require 'redis-objects'
require 'connection_pool'
require 'httparty'
require 'nokogiri'
require 'mechanize'
require 'logger'
require 'watir'

# Load environments
Dotenv.load(__dir__ + '/.env')

# Load project files
require __dir__ + '/src/Services/redis_service.rb'
require __dir__ + '/src/Services/html_service.rb'
require __dir__ + '/src/Services/scrapper.rb'
require __dir__ + '/src/Dto/job.rb'
require __dir__ + '/src/Actions/action.rb'
require __dir__ + '/src/Workers/worker.rb'
require __dir__ + '/src/app.rb'

Dir.mkdir __dir__ + '/logs' unless Dir.exist?  __dir__ + '/logs'
Dir.mkdir __dir__ + '/logs/png' unless Dir.exist? __dir__ + '/logs/png'

def get_log_filename
  filename = __dir__ + '/logs/' + Time.now.strftime("%d_%m_%Y_%H") + '.log'

  if File.exist? filename
  else
    File.open(filename, 'w') do |file|
      puts 'Application started'
    end
  end
end

def get_png_directory
  __dir__ + '/logs/png/'
end