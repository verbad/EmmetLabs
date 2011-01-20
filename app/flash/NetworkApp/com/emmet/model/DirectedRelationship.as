package com.emmet.model {
  import com.emmet.util.WanderXmlParser;
  
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.utils.Dictionary;
  
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;
  import mx.rpc.http.HTTPService;

  public class DirectedRelationship extends GraphElement {
    private var _id:int;
    private var _from:Person;
    private var _to:Person;
    private var _stub:Boolean;
    private var _dispatcher:EventDispatcher;

    private static var __fetched:Dictionary = new Dictionary(true);

    private static var __fromId:Dictionary = new Dictionary(true)

	public static var DEBUG_DO_FETCHING:Boolean = false;

    public static function fromXml(directedRelationshipXml:XML, personTypeAndIdToPerson:Object):DirectedRelationship {
      var id:int = directedRelationshipXml.@id;
      // Needs to be coerced into a string first
      // var stub:Boolean = directedRelationshipXml.@stub.toLowerCase == "true";
      var stubAttr:String = directedRelationshipXml.@stub
      var stub:Boolean = stubAttr.toLowerCase() == "true";
      var dr:DirectedRelationship = __fromId[id];

      if (dr == null) {
        // This is getting complex enough that it might be worth looping
        var fromId:int = directedRelationshipXml.@from_id;
        var fromType:String = directedRelationshipXml.@from_type;

        // Strings can't be undefined. Very interesting
        // if (fromType == undefined || fromType == "") {
        if (fromType =="") {
          fromType = "person";
        }

        var fromNodeId:String = fromType + "_" + fromId;
        var from:Person = personTypeAndIdToPerson[fromNodeId] || Person.byNodeId(fromNodeId);

        var toId:int = directedRelationshipXml.@to_id;
        var toType:String = directedRelationshipXml.@to_type;

        // Strings can't be undefined. Very interesting
        // if (toType == undefined || toType == "") {
        if (toType == "") {
          toType = "person"
        }
        var toNodeId:String = toType + "_" + toId;
        var to:Person = personTypeAndIdToPerson[toNodeId] || Person.byNodeId(toNodeId);

        dr = new DirectedRelationship(id, from, to, stub);
        __fromId[id] = dr;
        trace("DR: NEW " + (dr.stub ? " stub " : "      ") + dr.url);
      } else {
        trace("DR: old " + (dr.stub ? " stub " : "      ") + dr.url);

        if (dr.stub && !stub) {
          dr._stub = false;
          dr.fireLoadedEvents();
        }
      }

      return dr;
    }

    public static function forPair(id:int, from:Person, to:Person):DirectedRelationship {
      return new DirectedRelationship(id, from, to);
    }

    public function DirectedRelationship(id:int, from:Person, to:Person, stub:Boolean = true) {
      _id = id;
      _from = from;
      _to = to;
      _stub = stub;
      _dispatcher = new EventDispatcher();

      if (from == null || to == null) {
        trace ("Creating bogus DirectedRelationship. Breakpoint to see how!");
      }
      from.addDirectedRelationship(this);
    }

    public function get id():int {return _id;}
    public function get from():Person { return _from; }
    public function get to():Person { return _to; }
    public function get url():String { return "/pair/" + from.param + "/" + to.param; }
    public function get stub():Boolean { return _stub }
    public function set stub(s:Boolean):void { _stub = s }

    public function inverse():DirectedRelationship {
      return to.findDirectedRelationshipTo(from);
    }

    public function loadExtendedRelationships(onCompleteLoad:Function):void {
      // Local references for closure
      var ocl:Function = onCompleteLoad;
      // var current:DirectedRelationship = this;

      if (!wasFetched()) {
        var service:HTTPService = new HTTPService();
        //service.destination = url + ".xml";
        service.url = url + ".xml";
        //service.method = "POST";
        service.resultFormat = HTTPService.RESULT_FORMAT_E4X;
        service.addEventListener("result", 
                                function(event:ResultEvent):void {
                                  var result:XML = XML(event.result);

                                  var parser:WanderXmlParser = new WanderXmlParser();
                                  var directedRelationship:DirectedRelationship = parser.parse(result);
                                  // This is now handled in parser.parse
                                  // current.fetched();
                                  ocl();
                                  trace ("Finished " + url + ".xml");
                                });
        
        service.addEventListener("fault", 
                                function(event:FaultEvent):void {
                                  var faultString:String = event.fault.faultString;
                                  trace("ERR " +faultString);
                                  //Alert.show(faultstring);
                                });
        trace("Fetching " + url + ".xml");
        service.send();
      }
    }

    public override function toString():String {
      return from.toString() + " to " + to.toString();
    }

    public function get descendantCount():Number {
      return 1;
    }

    public function fetched():void {
      if (__fetched[this] == undefined) {
        __fetched[this] = 0;
      }

      var inverse:DirectedRelationship = this.inverse();

      if (__fetched[inverse] == undefined) {
        __fetched[inverse] = 0;
      }

      __fetched[this]++;
      __fetched[inverse]++;
      // Make sure this is reset
      this.stub = false;
      inverse.stub = false;
    }

    public function wasFetched():Boolean {
      trace("F: "  + this.url + " :: " + __fetched[this])
      //return !__fetched[this] == null;
      return __fetched[this] > 0;
    }

    public function targeted(event:Event):Boolean {
      return event.currentTarget == _dispatcher || event.target == _dispatcher || event.currentTarget == this || event.target == this;
    }
  }
}