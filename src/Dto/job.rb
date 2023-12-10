class Job
  attr_accessor :proxy, :return_type, :target, :flow

  def initialize(proxy, return_type, target, flow)
    @proxy = proxy
    @return_type = return_type
    @target = target
    @flow = flow.map do |step|
      Action.from_array(step)
    end
  end
end
