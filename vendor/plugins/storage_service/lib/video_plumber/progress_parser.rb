require File.join(File.dirname(__FILE__), 'time_progress_parsing_strategy')
require File.join(File.dirname(__FILE__), 'percentage_progress_parsing_strategy')

class ProgressParser
  def initialize(listener)
    @listener = listener
  end

  def parse(io)
    strategy = determine_strategy(io)
    while line = io.gets("\r")
      percentage = strategy.parse(line)
      @listener.progress_report(percentage) if percentage
    end
  end

  private
  def determine_strategy(io)
    line = io.gets("============")
    strategy = check_for_time_strategy(line)

    strategy ||= PercentageProgressParsingStrategy.new
  end

  def check_for_time_strategy(line)
    time = parse_time(line)
    TimeProgressParsingStrategy.new(time) if time
  end

  def parse_time(line)
    if time_matches = line.match(/time=(\d+(?:\.\d+)?)/)
      time_matches[1].to_f
    end
  end
end