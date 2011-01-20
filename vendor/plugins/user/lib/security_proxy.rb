module SecurityProxy
  def can_create?(object)
    object.creatable_by?(self)
  end

  def can_read?(object)
    object.readable_by?(self)
  end

  def can_update?(object)
    object.updatable_by?(self)
  end

  def can_destroy?(object)
    object.destroyable_by?(self)
  end  
end