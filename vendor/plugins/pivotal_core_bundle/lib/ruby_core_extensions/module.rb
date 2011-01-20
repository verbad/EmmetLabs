class Module
  def redefine_const(const_name, value)
    remove_const(const_name) if const_defined?(const_name)
    const_set(const_name, value)
  end
end
