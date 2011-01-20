module Immutable
  
  class AttemptToModifyImmutablePropertyViolation < RuntimeError  
  end
  
  def self.append_features(base)
    super
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def attr_immutable(name, options = {:raise => "is an immutable property"})
      define_method("#{name}=".to_sym) do |value|
        property = "@#{name}"
        if instance_variable_get(property).nil?
          instance_variable_set(property, value)
        else
          error_message = "#{name} #{options[:raise]}"
          raise AttemptToModifyImmutablePropertyViolation.new(error_message)
        end
      end
    end
  end

end