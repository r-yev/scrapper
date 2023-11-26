class Job
  attr :url, :selector
  attr_accessor :url, :selector

  def []=(key, value)
    case key
      when 'url' then @url = value
      when 'selector' then @selector = value
    else
      throw "No field with name " + key
    end
  end
end
