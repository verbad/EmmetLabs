require 'enumerator'
class Array

  def include_all?(other)
    for each in other
      return false unless self.include?(each)
    end
    true
  end
  
  def is_equivalent_to?(other)
    self.size == other.size && 
    self.include_all?(other) && 
    other.include_all?(self)
  end
  
  def sort_by_method(method_symbol)
    sort_by {|a| a.send(method_symbol)}
  end

  def split_by(by)
    enum_slice(by).to_a 
  end

  def insert_before(existing, new)
    position = index(existing)
    raise ArgumentError, "Element #{existing} doesn't exist in array" unless position
    insert(position, new)
  end

  def insert_after(existing, new)
    position = index(existing)
    raise ArgumentError, "Element #{existing} doesn't exist in array" unless position
    insert((position + 1), new)
  end
end
