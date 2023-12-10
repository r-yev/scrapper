class App
  attr :jobs_queue,
       :completed_jobs_queue,
       :results_queue,
       :scrapper_service,
       :redis_service

  def initialize
    @jobs_queue = ENV['QUEUE_JOBS']
    @completed_jobs_queue = ENV['QUEUE_COMPLETED_JOBS']
    @results_queue = ENV['QUEUE_RESULTS']
    @redis_service = RedisService.new
    @scrapper_service = Scrapper.new

    Watir.logger.output = get_log_filename
  end

  def run
    while Integer(@redis_service.llen @jobs_queue) > 0
      fetched = @redis_service.lpop(@jobs_queue, @completed_jobs_queue)

      if fetched.nil?
        throw new Exception('Nothing in queue')
      else
        parsed = JSON.parse(fetched)
        thread = Thread.new do
          job = Job.new(parsed['proxy'], parsed['return'], parsed['target'], parsed['flow'])
          worker = Worker.new @redis_service,
                              @scrapper_service,
                              @completed_jobs_queue,
                              @jobs_queue,
                              @results_queue,
                              @logger_service
          worker.work(job)
        end
        thread.join
      end
    end
  end

end
