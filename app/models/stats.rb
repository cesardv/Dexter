class Stats < Struct.new(:drop)

  def visits
    (REDIS.get(visits_key) || 0).to_i
  end

  def record
    REDIS.incr(visits_key)
  end

  private

  def visits_key
    "#{drop.id}:stats:visits"
  end
end
