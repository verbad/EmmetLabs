class String
  def to_id_name()
    self.gsub(" ","").underscore
  end

  def unquote
    self.gsub(/^('|")|('|")$/, '')
  end
end