class Stats < Struct.new(:drop)

  def visits
    (REDIS.llen(stats_key) || 0).to_i
  end

  def record(attributes)
    request = Request.new(attributes[:user_agent])

    stats   = request.attributes.merge({
      :timestamp => Time.now
    })

    REDIS.lpush(stats_key, stats.to_json)
  end

  def attributes
    (REDIS.lrange(stats_key, 0, -1) || []).collect do |row|
      ActiveSupport::JSON.decode(row).with_indifferent_access
    end
  end

  class Request < Struct.new(:user_agent)

    def attributes
      orange = AgentOrange::UserAgent.new(self.user_agent)

      { :user_agent => self.user_agent,
        :mobile     => orange.is_mobile?,
        :computer   => orange.is_computer?,
        :bot        => orange.is_bot? }
    end
  end

  private

  def stats_key
    "#{drop.id}:stats"
  end
end
