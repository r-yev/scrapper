require 'redis'

class RedisService
  attr :redis

  def initialize
    @redis = Redis.new(
      host: ENV['REDIS_HOST'],
      port: ENV['REDIS_PORT'],
      db: ENV['REDIS_DATABASE']
    )
  end

  def lpop (key, count = 1)
    @redis.lpop(key, Integer(count))
  end

  def rpush (queue, value)
    @redis.rpush queue, value
  end

end
