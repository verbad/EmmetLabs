package test.mocks {
  public class MockDescendantCountable {

    private var _count:Number;

    public function MockDescendantCountable(count:Number) {
      _count = count;
    }

    public function get descendantCount():Number {return _count;}
  }
}