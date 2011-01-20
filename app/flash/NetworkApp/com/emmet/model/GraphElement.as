package com.emmet.model {
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;

  import com.emmet.model.StubEvent;

  public class GraphElement extends EventDispatcher {
    public static var LOADED_EVENT:String = "LoadedEvent";
    public static var STUB_EVENT:String = "StubEvent";

    private static var __stubDispatcher:EventDispatcher = new EventDispatcher();

    public function GraphElement(target:IEventDispatcher=null) {
      super(target);
    }

    public function fireLoadedEvents():void {
      dispatchEvent(new Event(LOADED_EVENT))
      __stubDispatcher.dispatchEvent(new StubEvent(this));
    }

    public static function get stubDispatcher():EventDispatcher { return __stubDispatcher; }
  }
}