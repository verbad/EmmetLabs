class Date

  def formatted
    "#{self.strftime('%b')} #{self.day.to_s}, #{self.strftime('%Y')}"
  end

  def future?
    self > Date.today
  end

end