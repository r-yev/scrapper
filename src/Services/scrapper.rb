class Scrapper
  attr :http, :options, :html

  def initialize
    @http = HTTParty
    @options = {
      headers: {
        "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
      },
    }
  end

  public def crawl (link)
    response = @http.get(link, @options)
    @html = Nokogiri::HTML(response)
    self
  end

  public def get_by_query_select (selector)
    @html.css(selector)
  end

  public def get_html
    @html
  end

end