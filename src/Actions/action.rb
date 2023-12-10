class Action
  attr_accessor :action, :options, :wait
  attr_writer :action, :options, :wait

  def initialize(action = nil, options = {}, wait = nil)
    @action = action
    @options = options
    @wait = wait
  end

  def self.from_array(array)

    action = self.new

    unless array.nil?
      unless array['action'].nil?
        action.action = array['action']
      end

      unless array['options'].nil?
        action.options = array['options']
      end

      unless array['wait'].nil?
        action.wait = array['wait']
      end
    end

    action
  end
end
