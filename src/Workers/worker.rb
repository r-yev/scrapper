class Worker
  attr :redis_service,
       :scrapper_service,
       :completed_jobs_queue,
       :jobs_queue,
       :results_queue,
       :logger_service
       :browser_service

  def initialize(
    redis_service,
    scrapper_service,
    completed_jobs_queue,
    jobs_queue,
    results_queue,
    logger_service
  )
    @redis_service = redis_service
    @scrapper_service = scrapper_service
    @results_queue = results_queue
    @jobs_queue = jobs_queue
    @completed_jobs_queue = completed_jobs_queue
    @browser_service = Watir::Browser.new
    @logger_service = logger_service
  end

  def work (job)
    return_type = job.return_type

    @browser_service.goto "https://google.com"
    job.flow.each do |item|

      case item.action
      when "navigate"
        @browser_service.goto item.options['url']
      when "click"
        execute 'document.querySelector("' + item.options['selector'] + '").click()', item.wait
      when "set_attribute"
        execute 'document.querySelector("' + item.options['selector'] + '").' + item.options['attribute'] + '="' + item.options['value'] + '"', item.wait
      else
        throw new Exception "Unknown action"
      end

      screenshot
    end

    puts "Attempting to get HTML content of the element..."

    js_script = <<~JS
          function getHtmlBySelector(selector) {
            var element = document.querySelector(selector);
            return element ? element.outerHTML : null;
            }
    JS

    selector = "#page-container-1 > div > div"
    html = @browser_service.execute_script(js_script + "return getHtmlBySelector('#{selector}');")
    puts "HTML Content:\n#{html}"
    @browser_service.close
    # puts html

    # @redis_service.rpush(@results_queue, result.to_json)
  end

  private def screenshot
    filename = get_png_directory + Time.now.strftime("%s") + '.png'
    @browser_service.screenshot.save filename
  end

  private def execute(script, time = nil)
    puts script
    result = @browser_service.execute_script(script)
    puts time
    sleep time unless time.nil?
    result
  end

end
