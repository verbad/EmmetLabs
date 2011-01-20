class PercentageProgressParsingStrategy
  def parse(line)
    if matches = line.match(/^Pos:.+?\(\s?(\d+)%\)/)
      matches[1].to_i / 100.0
    end
  end
end