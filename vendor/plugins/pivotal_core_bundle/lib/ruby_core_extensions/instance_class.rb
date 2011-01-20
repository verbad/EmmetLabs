module Kernel
  def instance_class(&block)
    s = class << self
      self
    end
    return s.class_eval(&block) if block
    return s
  end
  alias_method :metaclass, :instance_class
end
