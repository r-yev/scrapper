require __dir__ + '/bootstrap.rb'

@jobs_queue = ENV['QUEUE_JOBS']
@completed_jobs_queue = ENV['QUEUE_COMPLETED_JOBS']
@results_queue = ENV['QUEUE_RESULTS']

@redis_service = RedisService.new
@scrapper_service = Scrapper.new

while Integer(@redis_service.llen @jobs_queue) > 0
  fetched = @redis_service.lpop(@jobs_queue, @completed_jobs_queue)

  if fetched.nil?
    throw new Exception('Nothing in queue')
  else
    job = JSON.parse(JSON.parse(fetched), object_class: Job)

    thread = Thread.new do
      worker = Worker.new @redis_service,
                          @scrapper_service,
                          @completed_jobs_queue,
                          @jobs_queue,
                          @results_queue
      worker.work(job)
    end

    thread.join
  end
end