class TimeProgressParsingStrategy
  def initialize(duration)
     @duration = duration
  end

  def parse(line)
    if matches = line.match(/^Pos:.+?(\d+\.\d+)s/)
      matches[1].to_f / @duration
    end
  end
end