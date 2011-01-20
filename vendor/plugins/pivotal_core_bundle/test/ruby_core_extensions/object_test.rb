dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

class ObjectExtensionTest < Pivotal::IsolatedPluginTestCase
  include FlexMock::TestCase
  
  def test_stub_with__should_stub_with_a_proc
    methods_spec = {
        "give_me_5" => proc {return 5},
        "double_as_hash" => proc {|value| return value => value},
    }
    object = Object.new
    object.stub_with!(methods_spec)
    assert_equal Object, object.class
    assert_equal 5, object.give_me_5
    assert_equal({5=>5}, object.double_as_hash(5))
  end
  
  def test_stub_with__should_stub_with_a_return_value
    methods_spec = {
        "give_me_5" => 5,
        "one_as_hash" => {:one => 1},
    }
    object = Object.new
    object.stub_with!(methods_spec)
    assert_equal Object, object.class
    assert_equal 5, object.give_me_5
    assert_equal({:one=>1}, object.one_as_hash)
  end
  
  class Fixture
    def initialize(this='this', that='that')
      @this = this
      @that = that
    end
  end

  def test_to_hash()
    assert_equal(Object.new.to_hash, Object.new.to_hash)
    assert_equal({'@this'=>1, '@that'=>2}.to_hash, Fixture.new(1, 2).to_hash)
    assert_not_equal({'@this'=>1, '@that'=>2}.to_hash, Fixture.new(1, 3).to_hash)
    assert_not_equal({'@this'=>1, '@that'=>2}.to_hash, Fixture.new(1).to_hash)
    assert_not_equal({'@this'=>1, '@that'=>2}.to_hash, Fixture.new.to_hash)
  end
  
  def test_equal_over_attributes?
    assert (Object.new.equal_over_attributes?(Object.new))
    assert ({'@this'=>1, '@that'=>2}.equal_over_attributes?(Fixture.new(1, 2)))
    assert !({'@this'=>1, '@that'=>2}.equal_over_attributes?(Fixture.new(1, 3))
    assert !({'@this'=>1, '@that'=>2}.equal_over_attributes?(Fixture.new(1)))
    assert !({'@this'=>1, '@that'=>2}.equal_over_attributes?(Fixture.new)))
  end

end

class Object
  public(:to_hash)
end
