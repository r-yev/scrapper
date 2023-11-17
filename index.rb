require __dir__ + "/src/Services/scrapper.rb"

scrapper_service = Scrapper.new
response = scrapper_service
             .crawl("https://scrapeme.live/shop/")
             .get_by_query_select('li.product')

