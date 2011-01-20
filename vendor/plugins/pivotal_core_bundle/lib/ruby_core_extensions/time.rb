class Time
  def to_mysql
    strftime("%y-%m-%d %H:%M:%S")
  end

  def dayth
    day.ordinalize
  end

  def amhour
    (hour % 12 == 0) ? 12 : hour % 12
  end

  def to_12
    sprintf("%d:%02d", amhour, min)
  end

  def to_ampm
    to_12 + " " + ((hour < 12) ? "AM" : "PM")
  end

  def to_dotted_date
    strftime("%m.%d.%y")
  end
  
  def to_human_timestamp
    strftime("%Y%m%d%H%M%S")
  end

  def to_dayth_of_year
    strftime("%B ") + dayth + ", " + strftime("%Y")
  end

  def rfc3339
    self.utc.strftime("%Y-%m-%dT%H:%M:%S-00:00") 
  end
end