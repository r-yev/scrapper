class RedisService
  attr :list
  attr_accessor :redis

  def initialize
    Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(:host => ENV['REDIS_HOST'], :port => ENV['REDIS_PORT']) }
    @list = Redis::List
  end

  def lpop (queue, completed)
    list = @list.new queue
    list.rpoplpush completed
  end

  def rpush (queue, value)
    list = @list.new queue
    list.push value
  end

  def llen (queue)
    list = @list.new queue
    Integer(list.size)
  end

end
