class String

  def sanitize
    downcase.gsub(/([^\w\s]|\(|\)|\_)/, ' ').gsub(/\s+/, ' ').strip
  end

  def dashify
    gsub(/[^a-z0-9]+/i, '-').gsub(/-$/i, '').gsub(/^-/i, '')
  end

  def escape_single_quote
    gsub(/\'/, %q/\\\'/)
  end

 def escape_double_quote
    gsub(/\'/, %Q/\\\"/)
 end

end