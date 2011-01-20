package com.emmet.wander {
  import flash.display.Loader;
  import flash.net.URLLoader;
  import flash.net.URLLoaderDataFormat;
  import flash.events.Event;
  import flash.net.URLRequest;

  public class XMLLoader {
    private static var _instance:XMLLoader;

    public static function set instance(instance:XMLLoader):void { _instance = instance; }
    public static function get instance():XMLLoader {
      if (_instance == null) _instance = new XMLLoader();
      return _instance;
    }

    public function loadXML(url:String, xmlLoaded:Function):void {
      var loader:URLLoader = new URLLoader();
      loader.dataFormat = URLLoaderDataFormat.TEXT;
      loader.addEventListener(Event.COMPLETE, function(event:Event):void { xmlLoaded(new XML(event.target.data)); });
      loader.load(new URLRequest(url));
    }
  }
}