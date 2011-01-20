class Node
  def self.find_person_or_entity_by_param(param)
    # Favor returning the Person in the case of a collision
    %w{Person Entity}.each  do |class_name| 
      e = class_name.constantize.find_by_param(param) 
      return e if e
    end
    return nil
  end
end