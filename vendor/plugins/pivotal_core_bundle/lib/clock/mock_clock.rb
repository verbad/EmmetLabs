class Clock
  def self.now
    @@now ||= Time.now
  end

  def self.now=(new)
    @@now = new
  end

  def self.tick(duration)
    now
    @@now += duration
  end

end