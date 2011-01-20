dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"
require 'enumerator'

class ArrayExtensionTest < Pivotal::IsolatedPluginTestCase
  
  def test_is_equivalent_to
    assert [].is_equivalent_to?([])
    assert [1, 2, 3].is_equivalent_to?([3, 1,2])
    assert [1, 2, 2].is_equivalent_to?([2, 1,2])
    
    assert ![1, 2, 4].is_equivalent_to?([3, 1,2])
    assert ![1, 2, 4].is_equivalent_to?([1, 2])
    assert ![1, 2, 4].is_equivalent_to?([1, 2, 4, 6])
    assert ![1, 2, 4].is_equivalent_to?([1, 2, 2])
    assert ![1, 2, 2].is_equivalent_to?([1, 2, 4])
  end

  def test_split_by
    # normal
    assert_equal [[1]],                  [1].split_by(1)
    assert_equal [[1], [2]],             [1,2].split_by(1)
    assert_equal [[1,2]],                [1,2].split_by(2)
    assert_equal [[1,2], [3]],           [1,2,3].split_by(2)
    assert_equal [[1,2], [3,4]],         [1,2,3,4].split_by(2)
    assert_equal [[1,2], [3,4], [5]],    [1,2,3,4,5].split_by(2)
    assert_equal [[1,2], [3,4], [5,6]],  [1,2,3,4,5,6].split_by(2)
    assert_equal [[1,2,3], [4,5,6]],     [1,2,3,4,5,6].split_by(3)
    assert_equal [[1,2,3], [4,5,6], [7]],[1,2,3,4,5,6,7].split_by(3)
    assert_equal [[1,2],[3,4],[5,6],[7]],[1,2,3,4,5,6,7].split_by(2)

    # null cases
    assert_equal [], [].split_by(2)
    assert_equal [[1,2,3,4]], [1,2,3,4].split_by(4)
    assert_equal [[1,2,3,4]], [1,2,3,4].split_by(10)

    # error cases
    assert_raise(ArgumentError) {
      [1,2,3,4].split_by(0)
    }
    assert_raise(ArgumentError) {
      [1,2,3,4].split_by(-1)
    }
  end

  def test_insert_before
    assert_equal [:foo, :baz, :bar], [:foo, :bar].insert_before(:bar, :baz)
    assert_equal [:foo, :baz, :bar, :foo, :bar], [:foo, :bar, :foo, :bar].insert_before(:bar, :baz)
    assert_raise(ArgumentError) { [].insert_before(:bar, :baz) }
  end

  def test_insert_after
    assert_equal [:foo, :bar, :baz], [:foo, :bar].insert_after(:bar, :baz)
    assert_equal [:foo, :bar, :baz, :foo, :bar], [:foo, :bar, :foo, :bar].insert_after(:bar, :baz)
    assert_raise(ArgumentError) { [].insert_after(:bar, :baz) }
  end

end