require 'dotenv'
require 'json'
require 'uri'
Dotenv.load(__dir__ + '/.env')

require __dir__ + '/src/Services/redis_service.rb'
require __dir__ + '/src/Services/scrapper.rb'
require __dir__ + '/src/Dto/job.rb'

def parse_html (data)
  arr = []
  arr.push('name' => data.name)

  if data.name == 'a'
    arr.push('link' => data.attribute('href'))
  end

  if data.name == 'img'
    arr.push('src' => data.attribute('src'))
  end

  if data.children.size > 0
    content = []

    data.children.each do |element|
      content.push(parse_html(element))
    end

    arr.push('content' => content)
  else
    unless data.content.empty? || (data.content.include? "\r\n")
      arr.push('content' => data.content)
    end
  end
  arr
end

def fix_links (element)

end