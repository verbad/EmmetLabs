package test.mocks {
  import com.emmet.util.UrlNavigation;

  public class MockUrlNavigation extends UrlNavigation {
    private var _lastUrlVisited:String;

    public override function go(url:String):void {
      _lastUrlVisited = url;
    }

    public function get lastUrlVisited():String { return _lastUrlVisited; }

    public function clearLastUrlVisited():void {
      _lastUrlVisited = null;
    }
  }
}