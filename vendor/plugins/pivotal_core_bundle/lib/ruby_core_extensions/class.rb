class Class
  
  def all_subclasses
    result = [self]
    ObjectSpace.each_object do |each|
      if each.kind_of?(Class) && each.superclass == self
        result += each.all_subclasses
      end
    end
    result
  end
  
end