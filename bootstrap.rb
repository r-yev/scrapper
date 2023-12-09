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

# Load environments
Dotenv.load(__dir__ + '/.env')

# Load project files
require __dir__ + '/src/Services/redis_service.rb'
require __dir__ + '/src/Services/services.rb'
require __dir__ + '/src/Services/html_service.rb'
require __dir__ + '/src/Services/scrapper.rb'
require __dir__ + '/src/Dto/job.rb'
require __dir__ + '/src/Workers/worker.rb'
require __dir__ + '/src/app.rb'