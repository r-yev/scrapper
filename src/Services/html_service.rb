class HtmlService
  def parse_html (data, job)
    arr = []
    arr.push('name' => data.name)

    if data.name == 'a'
      link = data.attribute('href')

      if link !=~ URI::regexp
        link = job.url + link
      end

      arr.push('link' => link)
    end

    if data.name == 'img'
      arr.push('src' => data.attribute('src'))
    end

    if data.children.size > 0
      content = []

      data.children.each do |element|
        content.push(parse_html(element, job))
      end

      arr.push('children' => content)
    else
      unless data.content.empty? || (data.content.include? "\r\n")
        arr.push('content' => data.content)
      end
    end
    arr
  end

end
