class Hash
  # todo: test

  def keys_to_strings
    out = {}
    each do |key,value|
      out[key.to_s] = value
    end
    out
  end

  def keys_to_symbols
    out = {}
    each do |key,value|
      if key.kind_of? String
        out[key.to_sym] = value
      else
        out[key] = value
      end
    end
    out
  end

end
