class Worker
  attr :redis_service, :scrapper_service, :completed_jobs_queue, :jobs_queue, :results_queue

  def initialize(
    redis_service,
    scrapper_service,
    completed_jobs_queue,
    jobs_queue,
    results_queue
  )
    @redis_service = redis_service
    @scrapper_service = scrapper_service
    @results_queue = results_queue
    @jobs_queue = jobs_queue
    @completed_jobs_queue = completed_jobs_queue
  end

  def work (job)
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
