package com.emmet.util {
  import flash.net.navigateToURL;
  import flash.net.URLRequest;

  public class UrlNavigation {
    private static var _instance:UrlNavigation;

    public static function get instance():UrlNavigation {
      if (_instance == null) {
        _instance = new UrlNavigation();
      }
      return _instance;
    }

    public function go(url:String):void {
      flash.net.navigateToURL(new URLRequest(url), "_top");
    }

    public static function set instance(instance:UrlNavigation):void { _instance = instance; }
  }
}