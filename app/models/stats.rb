class Stats < Struct.new(:drop)

  def visits
    (REDIS.llen(stats_key) || 0).to_i
  end

  def record(attributes)
    stats = attributes.merge({
      :timestamp => Time.now
    })

    REDIS.lpush(stats_key, stats.to_json)
  end

  def attributes
    (REDIS.lrange(stats_key, 0, -1) || []).collect do |row|
      ActiveSupport::JSON.decode(row).with_indifferent_access
    end
  end

  private

  def stats_key
    "#{drop.id}:stats"
  end
end
