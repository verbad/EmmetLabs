dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

class ClassTest < Pivotal::IsolatedPluginTestCase
  class A; end;
  class B < A; end;
  class C < A; end;
  class D < C; end;
  
  def test_all_subclasses
    assert A.all_subclasses.include?(A)
    assert A.all_subclasses.include?(B)
    assert A.all_subclasses.include?(C)
    assert A.all_subclasses.include?(D)
    
    assert C.all_subclasses.include?(C)
    assert C.all_subclasses.include?(D)
    
    assert D.all_subclasses.include?(D)
    
    assert B.all_subclasses.include?(B)
    assert !B.all_subclasses.include?(A)
    assert !B.all_subclasses.include?(C)
    assert !B.all_subclasses.include?(D)
  end
  
end