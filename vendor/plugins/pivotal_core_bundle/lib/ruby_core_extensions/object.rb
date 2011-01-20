require File.dirname(__FILE__) + "/instance_class"

class Object

  def define_instance_methods(methods_spec)
    methods_spec.each_pair do |method_name, method_value|
      if method_value.class == Proc || method_value.class == Proc
        define_instance_method(method_name, &method_value)
      else
        define_instance_method(method_name, method_value)
      end
    end
    return self
  end

  def mock_with(*args)
    warn %Q|mock_with is deprecated. Use stub_with! instead.\n#{caller.join("\n")}\n|
    define_instance_methods(*args)
  end
  def stub_with(*args)
    warn %Q|stub_with is deprecated. Use stub_with! instead.\n#{caller.join("\n")}\n|
    define_instance_methods(*args)
  end
  alias_method :stub_with!, :define_instance_methods

  def define_instance_method(method_name, return_value = nil, &block)
    if block_given?
      (class << self; self; end).class_eval do
        define_method method_name, &block
      end
    else
      (class << self; self; end).class_eval do
        define_method method_name do
          return_value
        end
      end
    end
  end

  def equal_over_attributes?(other)
    self.to_hash.sort == other.to_hash.sort
  end

  private
  def to_hash()
    hash = {}
    instance_variables.each {|each| hash[each] = instance_variable_get(each)}
    hash
  end
end