class Test::Unit::TestCase
 remove_method :default_test if method_defined?(:default_test)
end