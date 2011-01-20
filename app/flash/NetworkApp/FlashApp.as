package {
  import com.emmet.model.*;
  import com.emmet.util.DrawableView;
  
  import flash.display.*;
  import flash.events.*;
  import flash.net.*;
  import flash.text.*;

  public class FlashApp extends Sprite {

    [Embed(systemFont="Helvetica", fontName="_helvetica", mimeType="application/x-font")]
    private static var EMBEDDED_HELVETICA:String;

    [Embed(systemFont="Helvetica", fontName="_helvetica_italic", fontStyle=ITALIC, mimeType="application/x-font")]
    private static var EMBEDDED_HELVETICA_ITALIC:String;

    private static var __LOGGED_IN:Boolean;

    private var _xmlURL:String;
    private var _view:DrawableView;

    public function FlashApp() {
      init();
    }

    private function init():void {

      if (root.loaderInfo.parameters.xmlURL != null) {
        _xmlURL = root.loaderInfo.parameters.xmlURL;
      } else {
        _xmlURL = defaultXMLURL();
      }

      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      loadXML();
    }
    
    public static function get LOGGED_IN():Boolean {
      return __LOGGED_IN;
    }

    private function loadXML():void {
      var loader:URLLoader = new URLLoader();
      loader.dataFormat = URLLoaderDataFormat.TEXT;
      loader.addEventListener(Event.COMPLETE, onCompleteLoadXML);
      loader.load(new URLRequest(_xmlURL));
    }

    protected function onCompleteLoadXML(event:Event):void {
      var xml:XML = new XML(event.target.data);
      var loggedIn:Object = xml.attribute("logged_in")
      trace("LOGGED IN: " + loggedIn);
      if (loggedIn != null && loggedIn.toString() == "true") {
        __LOGGED_IN = true;
      } else {
        __LOGGED_IN = false;
      }
      
      _view = buildView(xml);
      setView(_view);
    }

    protected function setView(view:DrawableView):void {
      view.x = stage.stageWidth / 2;
      view.y = stage.stageHeight / 2;
      addChild(view);
      view.draw();
    }

    protected function buildView(xml:XML):DrawableView {
      throw "Please implement me!";
    }

    protected function defaultXMLURL():String {
      throw "Please implement me!";
    }
  }
}