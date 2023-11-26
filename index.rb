require __dir__ + '/bootstrap.rb'

@jobs_queue = ENV['QUEUE_JOBS']
@completed_jobs_queue = ENV['QUEUE_COMPLETED_JOBS']
@results_queue = ENV['QUEUE_RESULTS']

@redis_service = RedisService.new
@scrapper_service = Scrapper.new

def work
  fetched = @redis_service.lpop(@jobs_queue, @completed_jobs_queue)

  if fetched.nil?
    puts "Nothing in queue"
  else
    job = JSON.parse(JSON.parse(fetched), object_class: Job)

    elements = @scrapper_service.crawl(job.url)
                            .get_by_query_select(job.selector)

    result = []
    elements.each do |element|
      parsed = parse_html(element, job)
      result.push(parsed)
    end

    @redis_service.rpush(@results_queue, result.to_json)
  end
end

work