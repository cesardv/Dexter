class Stats < Struct.new(:drop)
  SECTIONS = 20

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
    @attributes ||= (REDIS.lrange(stats_key, 0, -1) || []).collect do |row|
      ActiveSupport::JSON.decode(row).with_indifferent_access
    end
  end

  def broken_data
    times = attributes.collect {|a| Time.parse(a[:timestamp])}
    Stats.break(times, times.last, Time.now, SECTIONS)
  end

  def self.break(times, start_time, end_time, sections)
    delta = (end_time - start_time) / sections
    return [] if delta.zero?

    stats = times.inject(Hash.new) do |acc, time|
      my_quartile = ((time - start_time)/ delta).floor
      existing = acc[my_quartile] || 0
      acc.merge!(my_quartile => existing + 1)
    end

    (0...sections).collect {|n| stats[n] || 0}
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
