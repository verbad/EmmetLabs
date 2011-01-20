package com.emmet.model
{
  import flash.events.Event;
  import flash.events.EventDispatcher;

  public class StubEvent extends Event
  {
    public static var EVENT:String = "StubEvent";

    private var _actee:GraphElement;

  // public function StubEvent(actee:GraphElement, type:String=StubEvent.EVENT, bubbles:Boolean=false, cancelable:Boolean=false)
     public function StubEvent(actee:GraphElement, type:String="StubEvent",     bubbles:Boolean=false, cancelable:Boolean=false) {
      _actee = actee;
      //TODO: implement function
      super(type, bubbles, cancelable);
    }

    public override function clone():Event {
      return new StubEvent(_actee, this.type, this.bubbles, this.cancelable);
    }

    public function get actee():GraphElement {return _actee;}

  }
}