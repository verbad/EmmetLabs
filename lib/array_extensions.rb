class Array

  # This code isn't production quality... good thing we're not using it for anything
  def to_ranges
    array = self.compact.uniq.sort
    ranges = []
    if !array.empty?
      # Initialize the left and right endpoints of the range
      left, right = array.first, nil
      array.each do |obj|
        # If the right endpoint is set and obj is not equal to right's successor 
        # then we need to create a range.
        if right && obj != right.succ
          ranges << Range.new(left,right)
          left = obj
        end
        right = obj
      end
      ranges << Range.new(left,right)
    end
    ranges
  end

end