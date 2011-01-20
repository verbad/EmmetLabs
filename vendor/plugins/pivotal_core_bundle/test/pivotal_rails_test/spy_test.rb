dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

class SpyTest < Test::Unit::TestCase
  def setup
    super
    @spy = Spy.new
  end
  
  def test_was_called
    @spy.foo
    assert @spy.was_called?(:foo)
    assert !@spy.was_called?(:bar)
  end
  
  def test_methods_called
    @spy.foo
    @spy.bar
    assert_equal [:foo, :bar], @spy.methods_called
  end
  
  def test_was_called_with_arguments
    @spy.foo(1)
    assert @spy.was_called?(:foo, 1)
    @spy.bar(1, 2, 3)
    assert @spy.was_called?(:bar, 1,2,3)
  end
  
  def test_was_called_exactly
    @spy.bar(1, 2, 3)
    assert @spy.was_called_exactly?(:bar, 1,2,3)
    assert !@spy.was_called_exactly?(:bar, 1,2,3,4)
  end
  
  def test_was_called_omitting_arguments
    @spy.foo(1,2)
    assert @spy.was_called?(:foo)
    assert @spy.was_called?(:foo,1,2)
  end
  
  def test_were_called
    @spy.foo(1)
    @spy.bar(1, 2, 3)
    assert @spy.were_called?([:foo, 1], [:bar, 1,2,3])
  end
  
  def test_were_called_omitting_args
    @spy.foo(1)
    @spy.bar(1, 2, 3)
    assert @spy.were_called?([:foo], [:bar])
  end
  
  def test_no_arguments_against_some
    @spy.foo(1)
    @spy.bar
    assert @spy.were_called?([:foo, 1], [:bar])
  end
  
  def test_assert_called
    @spy.foo(1)
    @spy.bar(1, 2, 3)
    @spy.assert_called [:foo, 1], [:bar, 1,2,3]
    begin
      @spy.assert_called [:baz, 1], [:bar, 1,2,3]
      assert false
    rescue => e
      assert_equal "Expected [[:baz, 1], [:bar, 1, 2, 3]]\n" +
      " but was [[:foo, 1], [:bar, 1, 2, 3]]", e.message
    end
    
  end
  
  def test_assert_called_exactly
    @spy.foo(1)
    @spy.bar(1, 2, 3)
    @spy.assert_called_exactly [:foo, 1], [:bar, 1,2,3]
    begin
      @spy.assert_called_exactly [:foo, 1], [:bar]
      assert false
    rescue => e
      assert_equal "Expected [[:foo, 1], [:bar]]\n" +
      " but was [[:foo, 1], [:bar, 1, 2, 3]]", e.message
    end
    
  end

  def test_last_method_called_with_arguments
    @spy.foo(1)
    @spy.bar(1, 2, 3)
    assert_equal [:bar, 1,2,3], @spy.last_method_called_with_arguments
  end
  
end
