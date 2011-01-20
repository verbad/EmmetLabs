class FixturesCollection < Hash
 def initialize(*args)
   super
   @loaded_fixtures = nil
 end

 def [](key)
   @loaded_fixtures
 end

 def []=(key, values)
   @loaded_fixtures = values
 end
end

class Test::Unit::TestCase
 @@already_loaded_fixtures = FixturesCollection.new
end
