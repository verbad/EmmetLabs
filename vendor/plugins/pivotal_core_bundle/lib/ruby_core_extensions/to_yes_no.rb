class FalseClass
  def to_yes_no
    "No"
  end
end

class TrueClass
  def to_yes_no
    "Yes"
  end
end

class NilClass
  def to_yes_no
    false.to_yes_no
  end
end
